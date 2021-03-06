#Create a simulator object
set ns [new Simulator]

#Creating nam file
set nf [open Q2-nosplit.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
        global ns nf nt nf1
        $ns flush-trace
	#Close the trace file
        close $nf
	#Execute nam on the trace file
        exec nam -k 5409 Q2-nosplit.nam &
        exit 0
}

#Different colours
$ns color 1 dodgerblue
$ns color 2 red
$ns color 3 cyan
$ns color 4 green
$ns color 5 yellow
$ns color 6 black
$ns color 7 magenta
$ns color 8 gold
$ns color 9 red

#Router node initialisation
set ROU1 [$ns node]


$ROU1 shape "square"



$ns at 0.0 "$ROU1 label ROU1"


#Creating the nodes for network and connecting them
for {set i 0} {$i < 150} {incr i} {
        set n($i) [$ns node]
	$ns duplex-link $n($i) $ROU1 10Mb 10ms DropTail
}


#TCP/FTP Connection 1
set tcp1 [$ns create-connection TCP $n(133) TCPSink $n(4) 1]
 $tcp1 set class_ 1
 $tcp1 set maxcwnd_ 16
 $tcp1 set packetsize_ 4000
 $tcp1 set fid_ 1
 set ftp1 [$tcp1 attach-app FTP]
 $ftp1 set interval_ .005
 $ns at 0.5 "$ftp1 start"
 $ns at 70.0 "$ftp1 stop"

#TCP/FTP Connection 2
set tcp2 [$ns create-connection TCP $n(99) TCPSink $n(5) 1]
 $tcp2 set class_ 1
 $tcp2 set maxcwnd_ 16
 $tcp2 set packetsize_ 4000
 $tcp2 set fid_ 2
 set ftp2 [$tcp2 attach-app FTP]
 $ftp2 set interval_ .005
 $ns at 1.0 "$ftp2 start"
 $ns at 75.0 "$ftp2 stop"

#TCP/FTP Connection 3 
set tcp3 [$ns create-connection TCP $n(60) TCPSink $n(148) 1]
 $tcp3 set class_ 1
 $tcp3 set maxcwnd_ 16
 $tcp3 set packetsize_ 4000
 $tcp3 set fid_ 3
 set ftp3 [$tcp3 attach-app FTP]
 $ftp3 set interval_ .005
 $ns at 1.5 "$ftp3 start"
 $ns at 80.0 "$ftp3 stop"

#TCP/FTP Connection 4
set tcp4 [$ns create-connection TCP $n(58) TCPSink $n(122) 1]
 $tcp4 set class_ 1
 $tcp4 set maxcwnd_ 16
 $tcp4 set packetsize_ 4000
 $tcp4 set fid_ 6
 set ftp4 [$tcp4 attach-app FTP]
 $ftp4 set interval_ .005
 $ns at 6.0 "$ftp4 start"
 $ns at 95.0 "$ftp4 stop" 
 
#TCP/FTP Connection 5 
set tcp5 [$ns create-connection TCP $n(144) TCPSink $n(117) 1]
 $tcp5 set class_ 1
 $tcp5 set maxcwnd_ 16
 $tcp5 set packetsize_ 4000
 $tcp5 set fid_ 7
 set ftp5 [$tcp5 attach-app FTP]
 $ftp5 set interval_ .005
 $ns at 15.0 "$ftp5 start"
 $ns at 95.0 "$ftp5 stop" 
 
#UDP/CBR Connection 1
set udp1 [new Agent/UDP]
$ns attach-agent $n(15) $udp1
set null1 [new Agent/Null]
$ns attach-agent $n(121) $null1
$ns connect $udp1 $null1
$udp1 set fid_ 4

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 1mb
$cbr1 set random_ false
$ns at 3.0 "$cbr1 start"
$ns at 85.0 "$cbr1 stop"

#UDP/CBR Connection 2
set udp2 [new Agent/UDP]
$ns attach-agent $n(24) $udp2
set null2 [new Agent/Null]
$ns attach-agent $n(11) $null2
$ns connect $udp2 $null2
$udp2 set fid_ 5


set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$cbr2 set type_ CBR
$cbr2 set packet_size_ 1000
$cbr2 set rate_ 1mb
$cbr2 set random_ false
$ns at 4.0 "$cbr2 start"
$ns at 90.0 "$cbr2 stop"

#UDP/CBR Connection 3
set udp3 [new Agent/UDP]
$ns attach-agent $n(87) $udp3
set null3 [new Agent/Null]
$ns attach-agent $n(20) $null3
$ns connect $udp3 $null3
$udp3 set fid_ 8


set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$cbr3 set type_ CBR
$cbr3 set packet_size_ 1000
$cbr3 set rate_ 1mb
$cbr3 set random_ false
$ns at 20.0 "$cbr3 start"
$ns at 100.0 "$cbr3 stop"


#Testing ping
Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "node [$node_ id] received ping answer from \
              $from with round-trip-time $rtt ms."
}
set p0 [new Agent/Ping]
$ns attach-agent $n(40) $p0
set p1 [new Agent/Ping]
$ns attach-agent $n(123) $p1
#Connect the two agents
$ns connect $p0 $p1
$ns at 0.2 "$p0 send"
$ns at 0.4 "$p1 send"
$ns at 0.6 "$p0 send"
$ns at 0.6 "$p1 send"


$ns at 105.0 "finish"


$ns run

