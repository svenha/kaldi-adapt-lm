"""Tools to handle system operations (copy, mkdir, simlink, etc.) and read templates"""

import os
import shutil
import errno
import logging

def symlink(targetfn, linkfn):
    try:
        os.symlink(targetfn, linkfn)
    except OSError as e:
        if e.errno == errno.EEXIST:
            logging.debug('symlink %s -> %s already exists' % (targetfn, linkfn))

def mkdirs(path):
    try:
        os.makedirs(path)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise

def copy_file (src, dst):
    logging.debug("copying %s to %s" % (src, dst))
    shutil.copy(src, dst)

def render_template(template_file, dst_file, **kwargs):
    """Copy template and substitute template strings
    File `template_file` is copied to `dst_file`. Then, each template variable
    is replaced by a value. Template variables are of the form
        {{val}}
    Example:
    Contents of template_file:
        VAR1={{val1}}
        VAR2={{val2}}
        VAR3={{val3}}
    render_template(template_file, output_file, val1="hello", val2="world")
    Contents of output_file:
        VAR1=hello
        VAR2=world
        VAR3={{val3}}
    :param template_file: Path to the template file.
    :param dst_file: Path to the destination file.
    :param kwargs: Keys correspond to template variables.
    :return:
    """
    with open(template_file) as f:
        template_text = f.read()

    dst_text = template_text

    for key, value in kwargs.items():
        dst_text = dst_text .replace("{{" + key + "}}", value)

    with open(dst_file, "wt") as f:
        f.write(dst_text)
