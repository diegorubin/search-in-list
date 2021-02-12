package filter;
use nginx;
use Search;

sub handler {
  my $r = shift;

  try {
    if (!Search::search($r->header_in("X-Entry"))) {
      $r->send_http_header("text/html");
      $r->status(403);
      $r->rflush;
      return OK;
    }
  
    $r->internal_redirect("/found");
    return OK;
  } catch {
    $r->send_http_header("text/html");
    $r->status(500);
    $r->rflush;
    return OK;
  }

}

sub found {
  my $r = shift;
  $r->send_http_header("text/html");
  $r->status(200);
  $r->rflush;
  return OK;
}

1;
__END__
