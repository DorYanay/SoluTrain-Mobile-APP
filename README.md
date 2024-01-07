# sport-fields

Managment sport fields mobile platform

* Superuser
* Manager
* Customer

DB

```mermaid
flowchart TD
    Users --> Trainer --> Groups
    Groups --> Meets
    Users --> Groups & Meets
```

Network diagram flow

```mermaid
flowchart LR
    Flutter(Flutter Dart) --> API(FastAPI python) --> PostgresSQL
```
