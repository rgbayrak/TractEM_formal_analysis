import dax
import os

proj_ID = 'Kirby21'

resources = ['NIFTI']

xutil = dax.XnatUtils

xnat = xutil.get_interface("http://xnat2.vanderbilt.edu:8080/xnat", "vuid", "password")

scans = xutil.list_project_scans(xnat, proj_ID)

if not os.path.exists(proj_ID):
	os.system("mkdir %s" % (proj_ID))

for scan in scans:
	scan_label = scan['scan_label']
	subj_label = scan['subject_label']
	sess_label = scan['session_label']

	if "MPRAGE" in scan_label:
	
		subj_dir = proj_ID + "/" + subj_label
		if not os.path.exists(subj_dir):
			os.system("mkdir %s" % (subj_dir))
	
		sess_dir = subj_dir + "/" + sess_label
		if not os.path.exists(sess_dir):
			os.system("mkdir %s" % (sess_dir))			
	
		s = '-x-'
		
		scan_name_full = proj_ID+s+subj_label+s+sess_label+s+scan_label
		path_to_file = sess_dir + "/" + scan_name_full
		new_path = sess_dir + "/MPRAGE-x-MPRAGE-x-MPRAGE"
		if not os.path.exists(sess_dir + "/" + scan_label):
			for resource in resources:
				command = "Xnatdownload -d " + sess_dir + \
					  	  " -p " + proj_ID + " --rs " + resource +\
					  	  " --selectionS " + scan_name_full
				os.system(command)
				os.system("mv " + path_to_file + " " + new_path)
