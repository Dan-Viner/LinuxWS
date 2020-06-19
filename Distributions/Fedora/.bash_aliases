alias a='alias'

a update='sudo dnf update -y && sudo dnf autoremove && sudo snap refresh'
a list_packages='comm -12 <(dnf leaves | sort) <(sudo dnf history userinstalled | sort)'
