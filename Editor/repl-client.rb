require "io/wait"
require "socket"

REPL_PORT = 11311
$input = ""
$input.force_encoding("UTF-8")
$s = UDPSocket.new

def repl_send code, strip_nil=false
  $s.send code, 0, "localhost", REPL_PORT
  $s.wait
  out = $s.recv($s.nread)
  print strip_nil ? out.gsub(/\s*nil$/, "\n") : out
  $stdout.flush
end

def balanced? code
  s = code.clone
  s.gsub! /[^\(\)\[\]\{\}]/, ""
  until s.gsub!(/\(\)|\[\]|\{\}/, "").nil?; end
  s.empty?
end

repl_send DATA.read.strip, true

while true
  $input += $stdin.gets.force_encoding("UTF-8")
  if balanced? $input
    repl_send $input
    $input = ""
  end
end

at_exit do
  $s.close
end

__END__
(do (println "; Arcadia REPL")
    (println (str "; Clojure " (clojure-version)))
    (println (str "; Unity " (UnityEditorInternal.InternalEditorUtility/GetFullUnityVersion)))
    (println (str "; Mono " (.Invoke (.GetMethod Mono.Runtime "GetDisplayName" (enum-or BindingFlags/NonPublic BindingFlags/Static)) nil nil))))