# DockerTest.pm
package DockerTest;

use IO::Socket::UNIX;
use JSON "decode_json";

sub getContainerInfo {
  my $container = shift;

  my $sock = IO::Socket::UNIX->new(
    Type => SOCK_STREAM(),
    Peer => "/var/run/docker.sock",
    Timeout => 1
  );
  $sock->print("GET /containers/${container}/json HTTP/1.0\n\n");

  my $res = "";
  while (my $line = $sock->getline) {
    $res .= $line;
  }
  $sock->close;
  return {} unless ($res =~ m{^HTTP/1\.0\s*200});

  (my $json = $res) =~ s/^[\s\S]*?\r\n\r\n//;
  my $data = decode_json($json);
  return $data;
}

sub getContainerAddress {
  my $container = shift;
  my $info = DockerTest::getContainerInfo($container);

  my $ip = $$info{"NetworkSettings"}{"IPAddress"};
  if (!$ip) {
    return "";
  }

  my $port = "80";
  if ($$info{"Config"}{"ExposedPorts"}) {
    my $exposedPorts = $$info{"Config"}{"ExposedPorts"};
    (keys %{$exposedPorts})[0] =~ /^(\d+)\/tcp/;
    $port = $1 || $port;
  }
  foreach my $env (@{$$info{"Config"}{"Env"}}) {
    next unless ($env =~ /^PROXY_PORT=(\d+)$/);
    $port = $1 || $port;
  }

  return "${ip}:${port}";
}

1;
__END__
