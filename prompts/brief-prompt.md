You are running as an autonomous agent for James Moore (WebTech HQ / AI Jedi).
This is an unattended run. Do NOT wait for user input at any point.
Handle all errors autonomously — log them and continue.

## Your Task

1. Determine today's date and set the output filepath:
   OUTPUT_FILE = /path/to/daily-tech-brief/output/briefs/YYYY-MM-DD.md

2. Use the `researcher` subagent to find the top 5 tech stories from the
   last 24 hours across these topics:
   - AI agents and agentic workflows
   - Model Context Protocol (MCP)
   - DevOps tooling (CI/CD, Kubernetes, Terraform)
   - AWS and cloud infrastructure
   - SRE practices and observability

3. The researcher subagent should save the completed brief to OUTPUT_FILE.

4. Prepend a header to the saved file in this format:
   # 🤖 AI Jedi Daily Brief — [Day, Month DD YYYY]
   *Generated at 1:00 AM MST by the Daily Tech Brief Agent*

   ---

5. Use the `post_file_to_slack` MCP tool to post the brief to #daily-brief
   with this header line:
   "🤖 *AI Jedi Daily Brief — [date]* | Good morning, James."

6. If web search returns no usable results, write the following to OUTPUT_FILE:
   "# Brief Unavailable — [date]\nNo results retrieved this run."
   Then post a short error notice to Slack:
   "⚠️ Daily brief agent ran at 1 AM but found no results. Check logs."

7. Log completion status (success or error) to:
   /path/to/daily-tech-brief/logs/run.log
   Format: [YYYY-MM-DD HH:MM] STATUS: <success|error> — <one line note>

Replace /path/to/daily-tech-brief with the actual absolute path to the project.
