require 'open-uri'

# Clean up old results
File.delete('results.out')

time = Time.new

# Earnings per share (2014)
earnings = {
"ADS.DE" => 3.12,
"ALV.DE" => 13.91,
"BAS.DE" => 5.55,
"BAYN.DE" => 6.04,
"BEI.DE" => 2.51,
"BMW.DE" => 9.00,
"CBK.DE" => 0.55,
"CON.DE" => 12.72,
"DAI.DE" => 6.46,
"DB1.DE" => 3.59,
"DBK.DE" => 1.31,
"DPW.DE" => 1.71,
"DTE.DE" => 0.63,
"EOAN.DE" => 0.93,
"FME.DE" => 2.76,
"FRE.DE" => 2.02,
"HEI.DE" => 3.87,
"HEN3.DE" => 4.27,
"IFX.DE" => 0.45,
"LHA.DE" => 1.10,
"LIN.DE" => 7.38,
"MRK.DE" => 4.64,
"LXS.DE" => 1.98,
"MUV2.DE" => 17.84,
"RWE.DE" => 2.21,
"SAP.DE" => 3.46,
"SDF.DE" => 1.70,
"SIE.DE" => 7.19,
"TKA.DE" => 0.43,
"VOW3.DE" => 21.87
}

# Read stock symbols
File.foreach("data/symbols-2014.cfg") do |symbol|
  sym = symbol.chomp
  open('tmp/'+sym, 'wb') do |file|
    url = "http://real-chart.finance.yahoo.com/table.csv?s=#{sym}&a=00&b=1&c=2013&d=#{time.month-1}&e=#{time.day}&f=#{time.year}&g=d&ignore=.csv"
    file << open(url).read
  end
  p "Downloaded historical data for symbol: " << sym
end

# Generate result data set
open("data/symbols-2014.cfg", 'r').each_with_index do |symbol, symidx|
  sym = symbol.chomp
  open('results.out', 'a') do |f|
    open('tmp/'+sym, 'r').each_with_index do |line, index|
      if index > 0
        tick = line.chomp.split(',')[6]
        pe_ratio = tick.to_f/earnings[sym]
        f.puts "#{index},#{symidx*20},#{pe_ratio}"
      end
    end
  end
end
