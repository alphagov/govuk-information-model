# GOV.UK Information Model
The GOV.UK Information Model contains the **canonical** information model for GOV.UK. It describes the information **conceptual** infrastructure for GOV.UK.

The Information Model consists of a set of [OWL](https://www.w3.org/OWL/) ontology text files that describe: 
- **Domain ontologies**. All the objects (classes and sub-classes) and the properties/attributes, for each domain. The domain describes the **canonical** objects for that domain. _E.g. Visa Domain_.
- **Content schemas**. All deployed content schemas (classes and sub-classes) and their properties/attributes. The content schemas are used to define objects in Content Blocks and Content Types (i.e "content") only objects. _E.g. Tax Content Block_.
- **Content types**. All deployed content types (classes and sub-classes) and their properties/attributes. The content types use the objects defined in the domains, augmented with UI (i.e "content") only objects. _E.g. answer Content Type_.
- **Taxonomies**. All Taxonomies used and all their taxons. The taxonomies exist in domains and content objects but are collected in one place for ease of management. _E.g. Language Taxonomy_.

Other supporting files are be stored in this repo. These provide documentation, model validation scripts, model export scripts, and other ad hoc files as needed.

The OWL ontology files are accessed using the public domain ontology editor [Protégé](https://protege.stanford.edu/).

## Repo Structure ##
| File | Description |
|:------|:-----|
|`GOVUKOntology.rdf`| The root ontology (information model). The separate ontology files that comprise the overall ontology are imported into this file. |
|`Properties.rdf`| All standard data properties, object properties, annotation properties, and datatypes. This ontology is imported into all ontology files. |
|`Domain/Domain*.rdf`|The list of separate domain ontologies, one ontology file per domain. Each domain ontology file is included in the root ontology file. The `DomainTemplate.rdf` file should be copied for new domains - see the [guide](https://gov-uk.atlassian.net/wiki/spaces/GIA/pages/edit-v2/5566988289) on how to do this.|
|`Taxonomy/Taxonomy*.rdf`|The list of separate taxonomy ontologies, one ontology file per taxonomy. Each taxonomy ontology file is included in the root ontology file. The `TaxonomyTemplate.rdf` file should be copied for new taxonomy - see the [guide](https://gov-uk.atlassian.net/wiki/spaces/GIA/pages/edit-v2/5566988289) on how to do this.|
|`ContentSchema/ContentSchema*.rdf`|The list of separate content schemas ontolgies, one ontology file per content schemas. Each content schemas ontology file is included in the root ontology file. The `ContentSchemaTemplate.rdf` file should be copied for new content schemas - see the [guide](https://gov-uk.atlassian.net/wiki/spaces/GIA/pages/edit-v2/5566988289) on how to do this.|
| `SHACL/*.ttl`|A folder of [SHACL](https://www.w3.org/TR/shacl/) validation files.|
|`XSLT/*.xslt`|A folder of [XSLT](https://en.wikipedia.org/wiki/XSLT) files used for detailed validation and information mode exports.|
| `ProtegeViewLayouts/*.xml`| Optional view layouts for the Protégé user interface. One file per view. |

## Related GitHub Repos ##
[Ontology Generation](https://github.com/alphagov/govuk-ai-accelerator/blob/main/docs/architecture/cross-repo-integration.md). Also see the associated [Confluence pages](https://gov-uk.atlassian.net/wiki/spaces/GOVUK/pages/5507776528/Ontology+Generator+run+books).

## Using Protégé ##
See the [Protégé documentation](https://gov-uk.atlassian.net/wiki/spaces/GIA/pages/5566988289/GDS+Ontologies) on Confluence.
