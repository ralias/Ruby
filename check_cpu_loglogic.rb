#!/usr/local/rvm//rubies/ruby-1.9.1-p378/bin/ruby
require 'rubygems'
require 'snmp'
require 'facets'

# Ricard Alias <ralias@uoc.edu> 11/06/2012

OK,WARN,CRIT,UNKNOWN = 0,1,2,3

manager = SNMP::Manager.new(:host => 'nemesis')
response = manager.get(["1.3.6.1.4.1.2021.11.52.0", "1.3.6.1.4.1.2021.11.50.0",.0"])
manager.close
total = 0
response.each_varbind{|i| total+=i.value}

manager = SNMP::Manager.new(:host => 'nemesis')
response = manager.get(["1.3.6.1.4.1.2021.11.53.0"])
ssCpuRawIdle = 0
response.each_varbind {|vb| ssCpuRawIdle= vb.value}
manager.close

idle= (ssCpuRawIdle.to_f / total.to_f ) * 100

if idle.between?(0,5) 
        puts "CRIT:"+idle.round_at(2).to_s+"% CPU Idle."
        exit CRIT
elsif idle.between?(5,25)
        puts "WARN"+idle.round_at(2).to_s+"% CPU Idle."
        exit WARN
elsif idle.between?(25,100)
        puts "OK: "+idle.round_at(2).to_s+"% CPU Idle."
        exit OK
else
        puts "UNKNOWN: "+idle.round_at(2).to_s+"% CPU Idle."
        exit UNKNOWN
end
