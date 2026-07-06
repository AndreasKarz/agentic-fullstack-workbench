param(
    [string]$SkillsPath = (Join-Path $PSScriptRoot '..\skills')
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -Path $SkillsPath -PathType Container)) {
    Write-Error "Skills path not found: $SkillsPath"
}

$workspaceRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$issues = New-Object System.Collections.Generic.List[string]
$skillNames = Get-ChildItem -Path $SkillsPath -Directory | Select-Object -ExpandProperty Name
$germanPattern = '[äöüÄÖÜß]|\b(Anforderung|Anforderungen|Akzeptanz|Testfall|Testfälle|Geschäft|Benutzer|Oberfläche|Prüfen|prüfen|Daten|Verfügbare|Begründung|Durchführung|Abschluss|Planung|Zustand|gültig|Fehler|Kündigung|Erstellen|Aktualisieren|Löschen|Bestätigung|muss|sollte|nicht|und|oder)\b'
$markdownLinkPattern = '\[[^\]]+\]\(([^)]+\.md(?:#[^)]+)?)\)'
$exampleLinkNames = @('DOCX-JS.md', 'EXAMPLES.md', 'FORMS.md', 'OOXML.md', 'REDLINING.md', 'REFERENCE.md')
$descriptionMaxLength = 500

Get-ChildItem -Path $SkillsPath -Directory | Sort-Object Name | ForEach-Object {
    $folderName = $_.Name
    $skillFile = Join-Path $_.FullName 'SKILL.md'

    if (-not (Test-Path -Path $skillFile -PathType Leaf)) {
        $issues.Add("${folderName}: missing SKILL.md")
        return
    }

    $text = Get-Content -Path $skillFile -Raw
    if ($text -notmatch '(?s)^---\s*\r?\n(.*?)\r?\n---') {
        $issues.Add("${folderName}: missing YAML frontmatter")
        return
    }

    $frontmatter = $matches[1]
    $name = $null
    if ($frontmatter -match '(?m)^name:\s*(.+?)\s*$') {
        $name = $matches[1].Trim().Trim('"').Trim("'")
    }

    if ([string]::IsNullOrWhiteSpace($name)) {
        $issues.Add("${folderName}: missing frontmatter name")
    }
    elseif ($name -ne $folderName) {
        $issues.Add("${folderName}: frontmatter name '$name' does not match folder")
    }

    $description = $null
    if ($frontmatter -match '(?ms)^description:\s*(?:>|>-)?\s*(.*?)(?:\r?\n[a-zA-Z_][\w-]*:|\z)') {
        $description = ($matches[1] -replace '\s+', ' ').Trim().Trim('"').Trim("'")
    }

    if ([string]::IsNullOrWhiteSpace($description)) {
        $issues.Add("${folderName}: missing frontmatter description")
    }
    else {
        if ($description.Length -gt $descriptionMaxLength) {
            $issues.Add("${folderName}: description too long ($($description.Length), max $descriptionMaxLength)")
        }

        if ($description -notmatch '(?i)\b(use when|use for|triggers?|when:)\b') {
            $issues.Add("${folderName}: description lacks trigger wording")
        }
    }

    $frontmatterLines = $frontmatter -split "\r?\n"
    for ($index = 0; $index -lt $frontmatterLines.Count; $index++) {
        if ($frontmatterLines[$index] -match '^requires:\s*$') {
            for ($requiresIndex = $index + 1; $requiresIndex -lt $frontmatterLines.Count; $requiresIndex++) {
                $line = $frontmatterLines[$requiresIndex]
                if ($line -match '^[a-zA-Z_][\w-]*:\s*') {
                    break
                }

                if ($line -match '^\s+-\s+(.+?)\s*$') {
                    $requiredSkill = $matches[1].Trim().Trim('"').Trim("'")
                    if ($requiredSkill -and $skillNames -notcontains $requiredSkill) {
                        $issues.Add("${folderName}: requires unknown skill '$requiredSkill'")
                    }
                }
            }
        }
    }

    $germanHits = [regex]::Matches($text, $germanPattern).Count
    if ($germanHits -gt 0) {
        $issues.Add("${folderName}: German/non-English signal count $germanHits")
    }
}

Get-ChildItem -Path $SkillsPath -Recurse -Filter *.md | ForEach-Object {
    $file = $_.FullName
    $text = Get-Content -Path $file -Raw
    $textForLinks = [regex]::Replace($text, '(?s)```.*?```', '')

    [regex]::Matches($textForLinks, $markdownLinkPattern) | ForEach-Object {
        $target = $_.Groups[1].Value
        if ($target -match '^(https?:|mailto:|#)') {
            return
        }

        $targetNoAnchor = ($target -split '#')[0]
        $targetFileName = Split-Path -Path $targetNoAnchor -Leaf
        if ($exampleLinkNames -contains $targetFileName) {
            return
        }

        $resolved = Join-Path (Split-Path -Path $file -Parent) $targetNoAnchor
        if (-not (Test-Path -Path $resolved -PathType Leaf)) {
            $relativeFile = [System.IO.Path]::GetRelativePath($workspaceRoot, $file)
            $issues.Add("${relativeFile}: broken markdown link '$target'")
        }
    }
}

if ($issues.Count -gt 0) {
    $issues | Sort-Object | ForEach-Object { Write-Output "ERROR: $_" }
    exit 1
}

Write-Output 'skills-ok'
