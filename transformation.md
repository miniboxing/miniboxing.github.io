---
layout: default
title: Transformation
short_title: Transformation
---

{% include oopsla.md %}

The transformation is comprehensively presented in the OOPSLA paper, so this page only lists the differences between `miniboxing` and `specialization`:

| Topic             | Miniboxing                 | Specialization              |
|-------------------|----------------------------|-----------------------------|
| Duplication       | 2 variants/type parameter: | 10 variants/type parameter: |
|                   |  - long integer and        |  - for each value type      |
|                   |  - references              |  - for references           |
| Type encoding     | in a separate type byte    | hardcoded in the variant    |
| Top of hierachy   | interface                  | generic class               |
|                   |  - no duplicate fields     |  - duplicate fields         |
|                   |  - miniboxed inheritance   |  - generic inheritance      |
| Rewiring          | same as specialization     | method, instantiation, parents |
| Characteristics   |  - annotation-driven       |  - annotation-driven        |
|                   |  - compatible              |  - compatible               |
|                   |  - opportunistic           |  - opportunistic            |


{% include oopsla2.md %}
