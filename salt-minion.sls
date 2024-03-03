# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# This software definition will only work in versions of Salt newer than
# 2015.8.2. In version 2015.8.2 we added the `use_scheduler` option which
# allowed us to launch the installer using the Windows task manager.
# This option is not available in earlier versions of Salt. So, while this
# software definition will allow you to install versions of Salt older than
# 2015.8.2 you will not be able to use pkg.install to upgrade Salt again. You
# will have to upgrade Salt through another means.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
{%- set install_dir = salt["reg.read_value"]("HKLM", "SOFTWARE\\Salt Project\\Salt", "install_dir").vdata %}
{%- set install_dir = install_dir or "C:\\salt" %}

# Starting in Version 3006 salt standardized builds across all OSes on the
# Relative Environment for Python project (relenv). The url changed as a result
{%- load_yaml as versions_relenv %}
- 3006.6
- 3006.5
- 3006.4
- 3006.3
- 3006.2
- 3006.1
- 3006.0
{%- endload %}

salt-minion-py3:
  # RELENV VERSIONS
  {%- for version in versions_relenv %}
  '{{ version }}':
    full_name: 'Salt Minion {{ version }} (Python 3)'
    {% if grains['cpuarch'] == 'AMD64' -%}
    installer: 'https://repo.saltproject.io/salt/py3/windows/minor/{{ version }}/Salt-Minion-{{ version }}-Py3-AMD64-Setup.exe'
    {% else -%}
    installer: 'https://repo.saltproject.io/salt/py3/windows/minor/{{ version }}/Salt-Minion-{{ version }}-Py3-x86-Setup.exe'
    {% endif -%}
    {% raw -%}
    # install_flags: "/S /master={{ salt['pillar.get']('salt:master', 'salt.domain.tld') }} /minion-id={{ salt['pillar.get']('salt:minion:ids:' ~ grains['host'] }}"
    {% endraw -%}
    install_flags: '/S'
    uninstaller: '{{ install_dir }}\uninst.exe'
    uninstall_flags: '/S'
    msiexec: False
    use_scheduler: True
    reboot: False
  {% endfor -%}
