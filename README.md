# GIS.lab customization for GISMentors training

GIS.lab: http://gislab-npo.github.io/gislab/

## Usage

### Physical

```sh
ansible-playbook --inventory-file=gislab-unit-gismentors.inventory \
   --private-key=/path/to/your/private/key \
   gislab-customize.yml
```

### Virtual

```sh
export GISLAB_PATH=~/git/gislab-npo/gislab

export PYTHONUNBUFFERED=1
export ANSIBLE_FORCE_COLOR=true
export ANSIBLE_HOST_KEY_CHECKING=false
export ANSIBLE_SSH_ARGS='\
    -o UserKnownHostsFile=/dev/null \
    -o ForwardAgent=yes \
    -o ControlMaster=auto \
    -o ControlPersist=60s'

ansible-playbook \
  --private-key=$GISLAB_PATH/.vagrant/machines/gislab_vagrant_bionic/virtualbox/private_key \
  --user=vagrant \
  --connection=ssh \
  --limit=gislab_vagrant_bionic \
  --inventory-file=$GISLAB_PATH/.vagrant/provisioners/ansible/inventory \
  --verbose \
  gislab-customize.yml
```
