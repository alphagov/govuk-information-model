# GOV.UK Information Model
The GOV.UK Information Model contains the **canonical** information model for GOV.UK. It describes the information **conceptual** infrastructure for GOV.UK.

The Information Model consists of a set of [OWL](https://www.w3.org/OWL/) text files that describe: 
- **Domain ontologies**. All the objects (classes and sub-classes) and the properties/attributes, for each domain. The domain describes the **canonical** objects for that domain. _E.g. Visa Domain_.
- **Content objects**. All deployed content objects (classes and sub-classes) and their properties/attributes. The content objects use the objects defined in the domains, augmented with UI (i.e "content") only objects. _E.g. Tax Content Block_.
- **Taxonomies**. All Taxonomies used and all their taxons. The taxonomies exist in domains and content objects but are collected in one place for ease of management. _E.g. Language Taxonomy_.

Other supporting files are be stored in this repo. These provide documentation, model validation scripts, model export scripts, and other files as needed.

The OWL files are accessed using the public domain ontology editor [Protégé](https://protege.stanford.edu/).
