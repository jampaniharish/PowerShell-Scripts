# edit the name field between quotes below

dsquery user -name "svc-view" | dsget user -memberof | dsget group -samid | out-file c:\User_Groups.txt