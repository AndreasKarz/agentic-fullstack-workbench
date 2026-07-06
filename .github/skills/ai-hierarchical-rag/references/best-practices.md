# Hierarchical RAG — Best Practices & Resources

> This file serves as a **living document**: check sources regularly for updates.  
> As of: February 2026

---

## Naming & Classification

The DIGEST/RAW pattern is **not a single standard** but combines several established concepts:

| Concept | Description |
|---------|-------------|
| **Hierarchical RAG** | Umbrella term for multi-tier retrieval architectures |
| **Context Distillation** | Token reduction through pre-processing (Anthropic) |
| **Summary Index** | Pre-computed summaries as index layer (LlamaIndex) |
| **Parent Document Retriever** | Chunk → original document navigation (LangChain) |
| **Context Engineering** | Deliberately shaping the LLM context window (Karpathy, 2025) |
| **Community Summaries** | Hierarchical summaries in GraphRAG (Microsoft) |

---

## Primary Sources (Theory & Architecture)

### Anthropic – Contextual Retrieval
- **URL:** https://www.anthropic.com/news/contextual-retrieval
- **Content:** How to enrich chunks with context before embedding; BM25 + embeddings combined
- **Relevance for DIGEST/RAW:** Foundation concept of pre-enrichment (our digest = pre-enriched context)

### Anthropic – Long Context Best Practices
- **URL:** https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/long-context-tips
- **Content:** How to pass large documents in a structured way; placement of important info
- **Relevance:** Explains why digest first (short document) + RAW on demand is better than loading everything

### Andrej Karpathy – Context Engineering (2025)
- **URL:** https://x.com/karpathy/status/1825455658987270151
- **Quote:** *"Context engineering is the delicate art and science of filling the context window with just the right information for the LLM to do the task at hand."*
- **Relevance:** Provides the umbrella term; explains why token budget must be managed deliberately

---

## Technical Implementations (Frameworks)

### LlamaIndex – Summary Index / Document Summary Index
- **URL:** https://docs.llamaindex.ai/en/stable/examples/index_structs/doc_summary/
- **Content:** Automatic generation of document summaries as an index layer; two-phase retrieval
- **Relevance:** The technical equivalent of our `20_folders/*.digest.md` files

### LlamaIndex – Recursive Retriever (Hierarchical)
- **URL:** https://docs.llamaindex.ai/en/stable/examples/retrievers/recursive_retriever_nodes/
- **Content:** Summary → Chunk → Full Document navigation; corresponds to Digest → RAW
- **Relevance:** Direct equivalent of our manual DIGEST/RAW structure

### LangChain – Parent Document Retriever
- **URL:** https://python.langchain.com/docs/how_to/parent_document_retriever/
- **Content:** Small chunks for retrieval, large chunks for context return
- **Relevance:** Same philosophy as DIGEST (retrieval) → RAW (complete document)

### LangChain – Contextual Compression
- **URL:** https://python.langchain.com/docs/how_to/contextual_compression/
- **Content:** Automatically trimming retrieved documents to relevant passages
- **Relevance:** What our digest does manually; can also be automated

---

## Microsoft GraphRAG

### GraphRAG – Community Summaries
- **URL:** https://microsoft.github.io/graphrag/
- **GitHub:** https://github.com/microsoft/graphrag
- **Arxiv Paper:** https://arxiv.org/pdf/2404.16130
- **Content:** Knowledge graphs + hierarchical community summaries for global vs. local queries
- **Relevance:** Our `10_topics/` layer corresponds to "Community Summaries"; `00_catalog.md` = global summary

### Microsoft Blog – GraphRAG Announcement
- **URL:** https://www.microsoft.com/en-us/research/blog/graphrag-unlocking-llm-discovery-on-narrative-private-data/
- **Content:** Explains why flat RAG fails for global questions; hierarchy as the solution

---

## Further Concepts

### RAPTOR – Recursive Abstractive Processing
- **URL:** https://arxiv.org/abs/2401.18059
- **Content:** Tree structure of summaries via recursive clustering; automated version of DIGEST
- **Relevance:** Theoretical foundation for multi-level summarization structures

### HippoRAG – Inspired by Human Memory
- **URL:** https://arxiv.org/abs/2405.14831
- **Content:** Episodic memory (RAW) + semantic memory (Digest/Index) combined
- **Relevance:** Biological analogy for the DIGEST/RAW concept

---

## Manual vs. Automated Comparison

| Aspect | DIGEST/RAW (manual) | LlamaIndex/LangChain (automated) |
|--------|---------------------|----------------------------------|
| Setup | One-time effort | Fast (automatic) |
| Summary quality | High (human-curated) | Variable (LLM-generated) |
| Maintenance | Manual on updates | Automatically re-indexable |
| Tokens for retrieval | Minimal (Markdown files) | Variable (embeddings + VectorDB) |
| Infrastructure | None (files only) | VectorDB required |
| Ideal for | Stable, structured knowledge | Frequently changing documents |

**Conclusion:** DIGEST/RAW is ideal for **stable project knowledge bases** such as extensive project documentation that changes slowly and should be manually quality-assured.

---

## Keep Current

Check these pages regularly (quarterly) for updates:
1. Anthropic Docs: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/
2. LlamaIndex Blog: https://www.llamaindex.ai/blog
3. LangChain Blog: https://blog.langchain.dev/
4. Microsoft graphrag Releases: https://github.com/microsoft/graphrag/releases
