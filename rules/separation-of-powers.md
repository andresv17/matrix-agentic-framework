# Regla: Separación de Poderes (The Source vs. The Matrix Crew)

## 1. El Dilema de la Auto-Auditoría
Cuando un modelo de IA genera código y simultáneamente es responsable de evaluarlo en la misma conversación, se produce un sesgo de auto-complacencia (*Echo Chamber*): el modelo "recuerda" lo que intentó escribir e ignora los errores reales en disco.

## 2. Los Dos Poderes del Framework
El framework divide formalmente las responsabilidades en dos planos independientes:

### A. Poder Ejecutivo (The Matrix Crew)
- **Roles:** `Morpheus`, `Architect`, `Keymaker`, `Trinity`, `Seraph`, `Link`, `Sati`, etc.
- **Misión:** Diseñar contratos, implementar código, estructurar UI, ejecutar tests unitarios/E2E, configurar pipelines de despliegue y escribir bitácoras.
- **Límite:** Ningún agente del Poder Ejecutivo puede auto-firmar compuertas finales de pase a producción, ni alterar las directivas soberanas sin auditoría.

### B. Poder Judicial y Soberano (The Source)
- **Rol:** `The Source` (operando como delegado de la Autoridad Humana / Neo).
- **Misión:** Auditar con ojos neutros y en frío contra el estado real del disco (`git diff`, reportes de pruebas, cumplimiento de especificaciones y contratos formales).
- **Entorno Recomendado:** Debe ejecutarse preferiblemente en un motor o instancia de IA independiente (por ejemplo, Google Antigravity o ChatGPT si la tripulación corre en Claude Code, o viceversa).
- **Canal de Enlace M2M (Logos):** La comunicación autónoma y desatendida entre ambos planos se realiza a través de `logos.json` y `scripts/logos.py`, permitiendo la supervisión continua sin fatiga humana.
