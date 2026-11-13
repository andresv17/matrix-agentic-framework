# Regla: Protocolo Write-Ahead Log (WAL) y Bus Central de Memoria

Este protocolo es obligatorio para todos los agentes del escuadrón.

## 1. Principio Fundamental
**Cero dependencia de la memoria de contexto del chat.**
Los LLMs sufren de olvido catastrófico cuando la ventana de contexto se satura o se compacta. Por tanto, la verdad del proyecto no reside en el chat, sino en los archivos de texto persistidos en el disco local.

## 2. El Mecanismo de Doble Registro
Ante cualquier micro-hito (decisión arquitectónica, análisis de seguridad, commit realizado, prueba ejecutada o compuerta superada):
1. **Bitácora Incremental del Rol (`log-<personaje>.md`):**
   El agente escribe primero un checkpoint detallado con sus notas, consideraciones técnicas y razonamiento en su propio archivo de bitácora (ej. `claude/log-architect.md` o `agent-logs/log-architect.md`).
2. **Entrada en el Bus Central (`registro-proceso.md`):**
   Escribe una única línea cronológica resumida en la tabla del bus central del proyecto antes de devolver la respuesta al usuario.

## 3. Comportamiento ante Proyectos Nuevos
Si la carpeta de logs no existe en el proyecto receptor, el primer agente en activarse la crea de inmediato junto con su archivo de bitácora individual y el bus central de registro.
