import setuptools

with open('README.md', 'r', encoding='utf-8') as fh:
    long_description = fh.read()

setuptools.setup(
    name='p4-simple-switch-cli',
    version='1.0.0',
    author='Christian Svensson',
    author_email='blue@cmd.nu',
    description='Stand-alone packaging of P4 behavioral-model client tool',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/bluecmd/p4-tools',
    project_urls={
        'Bug Tracker': 'https://github.com/bluecmd/p4-tools/issues',
    },
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: Apache Software License',
        'Operating System :: OS Independent',
    ],
    package_dir={'': 'src'},
    packages=setuptools.find_packages(where='src'),
    python_requires='>=3.6',
    install_requires=[
        'thrift'
    ],
    scripts=['simple_switch_CLI'],
)
