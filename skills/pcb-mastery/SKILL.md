---
name: pcb-mastery
description: Advanced KiCad automation workflows and electronic standards.
---

# KiCad MCP Best Practices
- **Layer Management:** Always verify the active layer before placing traces.
- **Net Assignment:** Ensure components are attached to the correct nets via MCP tools immediately after placement.
- **Reference Awareness:** When the user mentions a book in the `references/` folder, prioritize its design rules over generic defaults.

# Electronic Standards
- Follow IPC-2221 for trace spacing and width calculations.
- Maintain high-speed signal integrity by calculating impedance based on the project's stackup metadata.