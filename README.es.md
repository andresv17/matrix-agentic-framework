# ⚡ Matrix Agentic Framework — Escuadrón Virtual de Ingeniería de Software & Plano de Control Soberano

> **Fábrica de software agéntica y marco de ingeniería multi-agente, agnóstico a cualquier proveedor de IA (Claude, Gemini, OpenAI, Cursor, Antigravity).**
> Equipa tus proyectos con un escuadrón completo de 21 especialistas de ingeniería de software, memoria persistente en disco (Write-Ahead Log) y separación estricta de poderes mediante auditoría externa.

🌐 *[Read this documentation in English](README.md)*

---

## 🎯 ¿Para qué sirve este framework?

En el desarrollo asistido por IA habitual, un único asistente de chat intenta abarcar todo: diseñar la base de datos, escribir el backend, maquetar la UI, revisar la seguridad y correr pruebas. El resultado suele ser pérdida catastrófica de contexto, alucinaciones no detectadas y código superficial sin pruebas reales (*"AI Slop"*).

**Matrix Agentic Framework** resuelve esto convirtiendo tu entorno en una **fábrica de software virtual** con roles técnicos altamente especializados que colaboran, se auditan y debaten entre sí bajo un protocolo estricto de ingeniería guiada por especificaciones (**Spec-Driven Development**).

---

## 🏢 Los 21 Roles del Escuadrón

### A. Plano Soberano & Control Externo (Poder Judicial)
- **`The Source`** → **Director de Arquitectura & Auditor Soberano Externo.** Opera fuera de la tripulación ejecutora. Audita las afirmaciones de los agentes contra el disco real (`git diff`, contratos, suites de pruebas), aprueba compuertas formales de pase a producción y toma decisiones ejecutivas de Nivel 2.

### B. Dirección Técnica & Desarrollo (Poder Ejecutivo)
- **`/morpheus`** → **Capitán / Tech Lead.** Lee la cola de tareas, coordina subagentes, orquesta al equipo y activa compuertas estratégicas.
- **`/architect`** → **Arquitecto de Soluciones & SDD.** Diseña arquitectura limpia/hexagonal, define contratos formales (OpenAPI, JSON Schema, máquinas de estado) y blueprints técnicos antes de tocar una línea de código.
- **`/keymaker`** → **Senior Full-Stack Developer.** Desarrolla el código de producción y las suites de pruebas guiado estrictamente por contratos y especificaciones.
- **`/oracle`** → **Auditor Forense de Calidad & QA Gate.** Verifica en disco el cumplimiento de especificaciones, cobertura y emite veredictos formales de compuerta.
- **`/mouse`** → **Auditor Estructural de Trazabilidad.** Valida sintaxis, checklists y trazabilidad de IDs de especificación.

### C. Especialistas Técnicos de Dominio
- **`/trinity`** → **Ciberseguridad Ofensiva / Defensiva.** Caza vulnerabilidades OWASP, IDOR, CSRF, sanitización y auditoría SAST.
- **`/seraph`** → **Zero-Trust, Autenticación & Pruebas Extremas.** Audita sesiones seguras y desafía el código con pruebas de mutación (Stryker) y E2E (Playwright).
- **`/link`** → **Cloud, DevOps & SRE.** Docker, Terraform IaC, despliegues en GCP/AWS y pipelines de CI/CD en GitHub Actions.
- **`/sati`** → **Frontend, UI/UX & Accesibilidad.** Diseña componentes limpios, tokens de diseño CSS/Tailwind y garantiza WCAG 2.1 AA sin UI artificial.
- **`/rama`** → **Privacidad de Datos & Respaldos Atómicos.** Protección de PII, redacción de logs y transacciones ACID con rollback garantizado.
- **`/merovingian`** → **Análisis Causa-Raíz (RCA) & Dependencias.** Analiza el grafo de impacto de cambios y audita paquetes en busca de vulnerabilidades.

### D. Lentes Críticos, Debate & Calidad
- **`/mifune`** → **Pragmatismo Anti-Sobreingeniería.** Frena soluciones complejas innecesarias y asegura la ruta más directa y mantenible.
- **`/lock`** → **Abogado del Diablo.** Caza casos borde ocultos (`EDGE-*`), concurrencia y supuestos frágiles.
- **`/zion`** → **Arena de Debate Técnico.** Conduce debates estructurados (1v1, Clanes) entre agentes para destrabar dilemas de diseño.
- **`/dojo`** → **Refactorización Continua.** Diseña planes de limpieza y reducción de deuda técnica.
- **`/hamann`** → **Optimización de Contexto e IA.** Optimiza el consumo de tokens y la efectividad de las instrucciones.
- **`/neb`** → **Traductor de Estado.** Resume el avance técnico en lenguaje claro para stakeholders humanos.
- **`/hardline`** → **Protocolo de Cierre & Handover.** Congela el contexto, genera handovers fechados y emite prompts de despertar.

### E. Red Team (Chaos Engineering)
- **`/smith`** → **Chaos Engineering.** Simula caídas de base de datos, cortes de red y fallos transaccionales a mitad de ejecución.
- **`/sentinels`** → **Centinelas de Ataque.** Evalúa los vectores críticos de exploit (inyecciones, fuerza bruta, desbordamientos).

---

## ⚖️ ¿Cuándo SÍ y cuándo NO usar este framework?

### ✅ Casos de uso ideales:
1. **Proyectos de software de mediana a alta complejidad:** Aplicaciones full-stack, APIs empresariales, microservicios, plataformas SaaS y librerías donde intervienen múltiples disciplinas técnicas.
2. **Proyectos con tolerancia cero a la deuda técnica oculta (*AI Slop*):** Donde cada commit debe pasar compuertas de pruebas reales, linters y tipos estrictos antes de considerarse terminado.
3. **Desarrollos autónomos de larga duración:** Proyectos que requieren múltiples sesiones de trabajo sin perder el hilo ni la memoria de decisiones pasadas.

### ❌ Cuándo NO usarlo:
- Tareas de 5 minutos, scripts desechables o consultas de texto aisladas.
- Proyectos sin código ni desarrollo de software (ej. setup básico de cuentas, tareas administrativas o análisis puramente documental).

---

## 🏛️ La Regla de Oro: Separación entre Matrix y The Source

El framework establece una división estricta entre **ejecución** y **auditoría**:

```
┌────────────────────────────────────────────────────────────────────────┐
│  PLANO SOBERANO (Poder Judicial / Auditoría) — THE SOURCE              │
│  Entorno recomendado: Google Antigravity / Gemini / ChatGPT externo   │
│  • Audita contra disco real (git diff, contratos, tests).              │
│  • Emite firmas ejecutivas de Nivel 2 y aprueba compuertas.            │
└──────────────────────────────────┬─────────────────────────────────────┘
                                   │ Canal Logos (M2M / scripts/logos.py)
                                   ▼
┌────────────────────────────────────────────────────────────────────────┐
│  LA TRIPULACIÓN (Poder Ejecutivo) — THE MATRIX CREW (20 Roles)         │
│  Entorno recomendado: Claude Code CLI / Cursor / VS Code               │
│  • Diseña, programa, refactoriza, asegura y prueba.                    │
│  • Registra cada hito en el Write-Ahead Log (WAL) en disco.            │
└────────────────────────────────────────────────────────────────────────┘
```

### ¿Por qué se recomienda enfáticamente ejecutarlos en motores de IA separados?
1. **Ruptura de la cámara de eco (*Echo Chamber*):** Si el mismo modelo que programa el código es el encargado de auditarlo en la misma ventana, validará sus propias alucinaciones por sesgo de confirmación. Un motor externo analiza con ojos fríos el código real en disco.
2. **Separación de Poderes (Ejecutivo vs. Judicial):** El que construye no puede firmar su propio pase a producción.
3. **Preservación de Contexto:** La tripulación satura su contexto rápidamente con salidas de terminal y archivos de código. *The Source* mantiene un contexto limpio para tomar decisiones de arquitectura sin niebla de guerra.

> *Nota: Si no cuentas con dos proveedores de IA distintos, puedes ejecutar Source y Matrix en dos terminales independientes con el mismo modelo, pero **nunca en la misma sesión o conversación**.*

---

## 💾 Memoria Persistente: Protocolo Write-Ahead Log (WAL)

Ningún agente confía en la memoria efímera de la ventana de chat. Ante cada decisión o hito:
1. El agente escribe un checkpoint detallado en su bitácora individual: `claude/log-<personaje>.md` (o `agent-logs/log-<personaje>.md`).
2. Agrega una línea cronológica al bus central: `claude/registro-proceso-<proyecto>.md`.
3. Al iniciar sesión o compactar contexto, el hook `session-context.mjs` inyecta automáticamente el estado de Git y las últimas entradas del bus.

---

## 🚀 Instalación y Uso

### Opción A: Como Plugin Nativo (Google Antigravity)
Este repositorio incluye un manifiesto estándar `plugin.json`.
1. Clona o añade este repositorio en tu directorio de plugins o Plugins Manager.
2. Activa el plugin **Matrix Agentic Framework**. Todos los roles y reglas quedarán inmediatamente disponibles.

### Opción B: Mediante el Instalador Interactivo Multiplataforma (`install.sh`)
Clona el repositorio en tu máquina y ejecuta el script:

```bash
git clone https://github.com/andresv17/matrix-agentic-framework.git
cd matrix-agentic-framework

# Asistente interactivo adaptativo (pregunta dónde instalar cada parte):
./install.sh
```

El asistente interactivo te guiará paso a paso:
1. **¿Dónde instalar la Tripulación (Crew)?** (Claude Code, Antigravity, Cursor, ruta personalizada).
2. **¿Dónde instalar The Source?** Te recomendará automáticamente una IA distinta (ej. Gemini o ChatGPT si elegiste Claude) para garantizar la separación de poderes.
3. **¿Cómo enlazar los archivos?** (Enlaces simbólicos automáticos o copia física).
4. **¿Deseas inicializar un proyecto ahora?** (Opcional).

> *Si prefieres el modo no interactivo (CI/CD o scripts directos), puedes usar flags: `./install.sh --crew`, `./install.sh --source`, `./install.sh --all` o `--crew-dir <ruta>` / `--source-dir <ruta>`.*

### Inicializar un nuevo proyecto con la memoria de la Matrix
En la raíz de cualquier proyecto nuevo de software, ejecuta:

```bash
/ruta/hacia/matrix-agentic-framework/install.sh --init-project .
```

Esto aprovisionará:
- El bus central de eventos: `claude/registro-proceso-<tu-proyecto>.md`.
- El archivo de hechos fijos: `claude/entorno-y-lecciones.md`.
- El hook automático de inyección de contexto: `.claude/hooks/session-context.mjs`.
- La configuración de hooks de sesión: `.claude/settings.json`.
- El canal de comunicación M2M: `scripts/logos.py`.

---

## 🛸 El Canal Logos (Supervisión M2M Autónoma)

Para habilitar trabajo autónomo desatendido entre **The Source** y **Morpheus**:
1. En la terminal de la tripulación escribe:
   ```text
   Morpheus: enciende la Logos
   ```
2. En la terminal de The Source escribe:
   ```text
   Source: enciende la Logos
   ```
Ambos agentes coordinarán directivas, avances y auditorías forenses automáticamente mediante el bus de intercambio `logos.json` y `scripts/logos.py` sin requerir intervención humana constante. Para desactivar, basta con decir: `"apaga la Logos"`.

---

## 📄 Licencia

Distribuido bajo licencia MIT. Consulta `LICENSE` para más información.
