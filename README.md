# GOV.UK Information Model
The GOV.UK Information Model contains the **canonical** information model for GOV.UK. It describes the information **conceptual** infrastructure for GOV.UK. This in turn provides the underpinning for GOV.UK content and AI.

The Information Model consists of a set of [OWL](https://www.w3.org/OWL/) text files that describe: 
- **Domain ontologies**. All Domains, and the objects and properties/attributes they contain. Each domain describes the canonical objects for that domain. _E.g. Visa Domain_.
- **Content objects**. All deployed Content Objects and their properties/attributes. These content objects use the objects defined in the domains, augmented with UI (content) only objects. _E.g. Tax Content Block_.
- **Taxonomies**. All Taxonomies used and all their taxons. The taxonomies will exist in domains and content objects but will be collected in one place for ease of management. _E.g. Language Taxonomy_.

Other supporting files will be stored in this repo. These provide documentation, model validation scripts, model export scripts, and other files as needed.
