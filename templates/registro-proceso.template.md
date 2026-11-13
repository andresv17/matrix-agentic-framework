# Registro Central del Proceso SDD — Proyecto {{PROJECT_NAME}} (Bus Inter-Sesión)

> **Propósito:** Bus central de memoria persistente en disco para las skills de *The Matrix* en {{PROJECT_NAME}}. Ninguna skill depende de la ventana de contexto: toda decisión, commit, hallazgo o transición se registra aquí y en su respectiva bitácora (`claude/log-<personaje>.md` o `agent-logs/log-<personaje>.md`).

---

## 1. Fotografía de Estado Inicial en Disco

- **Autoridad Soberana (Nivel 2):** {{AUTHOR_NAME}}
- **Rama Activa:** `main` (o rama de trabajo)
- **Estado Inicial:** Bootstrap inicial de la arquitectura.
- **Directorio de Artefactos de Verdad:**
  - Especificaciones y Contratos: `specs/`
  - Código Fuente: `src/`
  - Pruebas y Compuertas: `tests/`

---

## 2. Bitácora Cronológica del Bus (Write-Ahead Log)

| Fecha y Hora | Emisor / Rol | Acción / Commit / Hito | Estado / Veredicto | Siguiente Acción |
| :--- | :--- | :--- | :--- | :--- |
| {{DATE}} | /architect | Blueprint inicial y mapa de especificaciones | APPROVED | Pasar diseño a /keymaker |
