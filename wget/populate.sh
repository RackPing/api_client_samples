#!/bin/bash

mylang=py

for i in rp_list_checks rp_pause_check rp_resume_check rp_pause_maint rp_resume_maint rp_add_check rp_del_check rp_list_contacts rp_add_contact rp_del_contact rp_update_contact; do
   cp -p sample.$mylang $i.$mylang
   chmod 755 $i.$mylang
done

