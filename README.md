# GIS.lab customization for GISMentors training

GIS.lab: http://web.gislab.io/

## Usage

        ansible-playbook -inventory-file=gislab-unit-gismentors.inventory --private-key=/path/to/your/private/key \
        gislab-server-customize.yml
   
        ansible-playbook -inventory-file=gislab-unit-gismentors.inventory --private-key=/path/to/your/private/key \
        gislab-grass-trunk.yml
   
        ansible-playbook -inventory-file=gislab-unit-gismentors.inventory --private-key=/path/to/your/private/key \
        gislab-client-customize.yml
