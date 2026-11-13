# Entorno Local y Lecciones Permanentes ({{PROJECT_NAME}})

> Archivo curado de consulta rápida (< 40 líneas) para evitar releer bitácoras extensas al arrancar sesión en cualquier motor de IA.

- **Puertos de desarrollo:** API local en `127.0.0.1:3000`, Web/Frontend en `127.0.0.1:5173`.
- **Runtime y Dependencias:** Runtime principal, versiones de Node/Python/Go y variables esenciales.
- **Reglas Críticas de UI y Arquitectura:**
  - Prohibido "AI Slop" (cero UI muerta o decorativa sin funcionalidad de negocio real).
  - Toda nueva ruta o endpoint requiere primero su contrato o esquema formal.
- **Compuertas de Verificación:**
  - Pruebas unitarias y de integración.
  - Verificación de tipos estricta (`tsc --noEmit`, linters).
  - Veredicto de `/oracle` antes de firmar cualquier entrega final.
