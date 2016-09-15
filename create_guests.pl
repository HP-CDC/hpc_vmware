#!/usr/bin/perl
#
## Provision some HPC nodes in VMware
#
$user=$ARGV[0];
$pass=$ARGV[1];

#my @hosts = ( c001,c002,c003,c004,c005,c006,c007,c008,c009,c010,c011,c012);
$nodetype='c';
$nodeprefix="aspv-infh-";
$server = 'vcenter.murphyhouse.us';
$dc = 'lab';
$vmhost = '10.0.10.141';
$net = 'dpg1';
$disk=  '50000000';
$mem = '1024';

#for $elem (@hosts) {
for (my $i=1; $i <= 3; $i++){
	 #   print $elem."\n";
	 $nodenum=sprintf("%.3d", $i);
	 $node=$nodeprefix . $nodetype . $nodenum;
	 $out_create = `perl vmprovision.pl --op=create --vmname=$node --datacenter=$dc --username=$user --password=$pass --server=$server --vmhost=$vmhost --nic_network=$net --disksize=$disk --memory=$mem`;
	 sleep 5;
	 $out = `perl updateVMBootOrder.pl --server=$server --username=$user --password=$pass --vmname=$node --operation=update --bootorder=ethernet,disk --nickey=4000 --diskkey=2000`;
	 $out_poweron = `perl powerops.pl --operation=poweron --vmname=$node --username=$user --password=$pass --server=$server`;

	`insert-ethers --hostname $node --membership Compute`;
	
	 #$out_poweron = `perl powerops.pl --operation=reset --vmname=$node --username=$user --password=$pass --server=$server`;
	 print("$node: $out_create - $out ; $out_poweron");
	 
	
}