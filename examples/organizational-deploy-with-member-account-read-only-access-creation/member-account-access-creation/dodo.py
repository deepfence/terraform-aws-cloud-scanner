from jinja2 import Environment, FileSystemLoader
from pathlib import Path

def task_render():
    """ "Render jinja2 templates.
    Yields:
        Render task for each jinja2 template file.
    """
    cwd = Path(".")
    environment = Environment(loader=FileSystemLoader(cwd))
    j2_templates = cwd.glob("*.j2")

    def render_template(template_path):
        """Render template.
        Args:
            template_path: Path to jinja2 template file
        """
        template = environment.get_template(str(template_path))
        with open(f"{template_path.stem}", "w") as output_file:
            output_file.write(template.render(data=account_details))

    for j2_template in j2_templates:
        target = f"_{j2_template.stem}"
        yield {
            "name": target,
            "actions": [
                (
                    render_template,
                    [j2_template],
                    {},
                ),
            ],
            "file_dep": [j2_template],
            "targets": [target],
            "clean": True,
        }