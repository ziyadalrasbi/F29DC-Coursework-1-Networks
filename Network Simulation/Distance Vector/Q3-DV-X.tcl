#Create a simulator object
set ns [new Simulator]

#Creating trace file
set nt [open Q3-DV-X.tr w]
$ns trace-all $nt

#Distance vector protocol
$ns rtproto DV

#Define a 'finish' procedure
proc finish {} {
        global ns nf nt nf1
        $ns flush-trace
        exit 0
}

#Different colours
$ns color 1 dodgerblue
$ns color 2 red
$ns color 3 pink
$ns color 4 green
$ns color 5 yellow
$ns color 6 black
$ns color 7 magenta
$ns color 8 gold
$ns color 9 red

#Router nodes initialisation

set ROU1 [$ns node]
set ROU2 [$ns node]
set ROU3 [$ns node]

$ROU1 shape "square"
$ROU2 shape "square"
$ROU3 shape "square"


$ns duplex-link $ROU2 $ROU1 10Mb 10ms DropTail
$ns duplex-link $ROU1 $ROU2 10Mb 10ms DropTail
$ns duplex-link $ROU1 $ROU3 10Mb 10ms DropTail
$ns duplex-link $ROU3 $ROU1 10Mb 10ms DropTail
$ns duplex-link $ROU2 $ROU3 10Mb 10ms DropTail
$ns duplex-link $ROU3 $ROU2 10Mb 10ms DropTail



$ns queue-limit $ROU1 $ROU2 40
$ns queue-limit $ROU2 $ROU1 50
$ns queue-limit $ROU1 $ROU3 40
$ns queue-limit $ROU3 $ROU1 50
$ns queue-limit $ROU2 $ROU3 40
$ns queue-limit $ROU3 $ROU2 50


$ns duplex-link-op $ROU2 $ROU1 queuePos 0.5
$ns duplex-link-op $ROU1 $ROU2 queuePos 0.5
$ns duplex-link-op $ROU1 $ROU3 queuePos 0.5
$ns duplex-link-op $ROU3 $ROU1 queuePos 0.5
$ns duplex-link-op $ROU2 $ROU3 queuePos 0.5
$ns duplex-link-op $ROU3 $ROU2 queuePos 0.5

$ns at 0.0 "$ROU1 label ROU1"
$ns at 0.0 "$ROU2 label ROU2"
$ns at 0.0 "$ROU3 label ROU3"


$ns duplex-link-op $ROU1 $ROU2 color cyan
$ns duplex-link-op $ROU1 $ROU3 color cyan
$ns duplex-link-op $ROU2 $ROU3 color cyan



#Creating the nodes for first subnetwork
for {set i 0} {$i < 25} {incr i} {
        set n($i) [$ns node]
	$ns duplex-link $n($i) $ROU1 10Mb 10ms DropTail
}


#Creating the nodes for second subnetwork
for {set j 25} {$j < 50} {incr j} {
        set n($j) [$ns node]
	$ns duplex-link $n($j) $ROU2 10Mb 10ms DropTail
}

#TCP/FTP Connection 1
set tcp1 [$ns create-connection TCP $n(1) TCPSink $n(37) 1]
 $tcp1 set class_ 1
 $tcp1 set maxcwnd_ 16
 $tcp1 set packetsize_ 4000
 $tcp1 set fid_ 1
 set ftp1 [$tcp1 attach-app FTP]
 $ftp1 set interval_ .005
 $ns at 0.5 "$ftp1 start"
 $ns at 70.0 "$ftp1 stop"

#TCP/FTP Connection 2
set tcp2 [$ns create-connection TCP $n(2) TCPSink $n(48) 1]
 $tcp2 set class_ 1
 $tcp2 set maxcwnd_ 16
 $tcp2 set packetsize_ 4000
 $tcp2 set fid_ 2
 set ftp2 [$tcp2 attach-app FTP]
 $ftp2 set interval_ .005
 $ns at 1.0 "$ftp2 start"
 $ns at 75.0 "$ftp2 stop"

#TCP/FTP Connection 3 
set tcp3 [$ns create-connection TCP $n(47) TCPSink $n(6) 1]
 $tcp3 set class_ 1
 $tcp3 set maxcwnd_ 16
 $tcp3 set packetsize_ 4000
 $tcp3 set fid_ 3
 set ftp3 [$tcp3 attach-app FTP]
 $ftp3 set interval_ .005
 $ns at 1.5 "$ftp3 start"
 $ns at 80.0 "$ftp3 stop"

#TCP/FTP Connection 4
set tcp4 [$ns create-connection TCP $n(45) TCPSink $n(20) 1]
 $tcp4 set class_ 1
 $tcp4 set maxcwnd_ 16
 $tcp4 set packetsize_ 4000
 $tcp4 set fid_ 6
 set ftp4 [$tcp4 attach-app FTP]
 $ftp4 set interval_ .005
 $ns at 6.0 "$ftp4 start"
 $ns at 95.0 "$ftp4 stop" 
 
#TCP/FTP Connection 5 
set tcp5 [$ns create-connection TCP $n(44) TCPSink $n(17) 1]
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
$ns attach-agent $n(43) $null1
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
$ns attach-agent $n(33) $udp2
set null2 [new Agent/Null]
$ns attach-agent $n(10) $null2
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
$ns attach-agent $n(29) $udp3
set null3 [new Agent/Null]
$ns attach-agent $n(8) $null3
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
$ns attach-agent $n(12) $p0
set p1 [new Agent/Ping]
$ns attach-agent $n(41) $p1
#Connect the two agents
$ns connect $p0 $p1
$ns at 0.2 "$p0 send"
$ns at 0.4 "$p1 send"
$ns at 0.6 "$p0 send"
$ns at 0.6 "$p1 send"


#Link loss at certain times
$ns rtmodel-at 1.0 down $ROU1 $ROU2
$ns rtmodel-at 5.0 up $ROU1 $ROU2
$ns rtmodel-at 10.0 down $ROU1 $ROU2
$ns rtmodel-at 15.0 up $ROU1 $ROU2
$ns rtmodel-at 50.0 down $ROU1 $ROU2
$ns rtmodel-at 60.0 up $ROU1 $ROU2

$ns at 100.0 "finish"





$ns run

