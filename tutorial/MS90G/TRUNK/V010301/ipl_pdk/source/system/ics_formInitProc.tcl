global _starc_cb_param_table


proc ics_formInitProc { instID } {
    set inst $instID
    ics_copyCdfgData $instID
}

proc ics_copyCdfgData {instID } {
    global _starc_cb_param_table

    set params [db::getParams -of $instID]
    set inst_name [oa::getName $instID]
#    puts "Copying $inst_name"	
    db::foreach param $params {
	set pname  [db::getAttr name -of $param]
	set pval   [db::getAttr value -of $param]
	set does_exist [info exists _starc_cb_param_table($inst_name,$pname)]
 #       puts "$inst_name $pname $does_exist"
	while {$does_exist} {
#	    puts "removing $inst_name $pname"
    	    unset _starc_cb_param_table($inst_name,$pname) 
	    set does_exist [info exists _starc_cb_param_table($inst_name,$pname)] 
#	    puts "$inst_name $pname $does_exist"
	}
	set _starc_cb_param_table($inst_name,$pname) $pval
    }
}

proc ics_rollbackCdfgData {instID } {
    global _starc_cb_param_table
#    puts "rollback"
    set params [db::getParams -of $instID]
    set inst_name [oa::getName $instID]
    foreach key [array names  _starc_cb_param_table] {
	set inst [lindex [split  $key "," ] 0]
	set param [lindex [split $key ","]  1]
#	puts "$inst $param $inst_name"
        if { $inst == $inst_name} {
#	    puts "Restoring: $inst $param $_starc_cb_param_table($key)"
    	    starcMS90G_symSetParam $param $_starc_cb_param_table($key) $instID
	}
    }
}




proc ics_formDoneProc { instID } {
    global _starc_cb_param_table
    set inst $instID
    set w             [starcMS90G_symGetParam w $inst]
#    puts "TESTING DONE PROC [oa::getName $instID] w=$w"
    set params [db::getParams -of $instID]
    set inst_name [oa::getName $instID]
    foreach key [array names  _starc_cb_param_table] {
	set inst [lindex [split  $key "," ] 0]
	set param [lindex [split $key ","]  1]
#	puts "$inst $param $inst_name"
        if { $inst == $inst_name} {
#	    puts "unsetting: $inst $param $key $_starc_cb_param_table($key)"
    	    unset _starc_cb_param_table($key) 
	}
    }


}

