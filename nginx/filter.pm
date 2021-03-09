package filter;
use nginx;
use Search;
use HTTP::Tiny;
use threads ('yield',
             'stack_size' => 64*4096,
             'exit' => 'threads_only',
             'stringify');

sub handler {
  my $r = shift;
  try {
    my $response = HTTP::Tiny->new->get('https://www.google.com');
 
    if($response->{success}) {
      if (!Search::search($r->header_in("X-Entry"))) {
        $r->internal_redirect("/not-found");
        return OK;
      }
      $r->internal_redirect("/found");
    } else {
      $r->internal_redirect("/not-found");
    }

    return OK;
  } catch {
    $r->send_http_header("text/html");
    $r->status(500);
    $r->rflush;
    return OK;
  }
}

sub asynchandler {
  my $r = shift;
  try {

    my $thr = threads->create('do_request', $r);

    $r->variable("thread", $thr->tid);
    $r->sleep(10, \&wait_request);

    return OK;

  } catch {
    $r->send_http_header("text/html");
    $r->status(500);
    $r->rflush;
    return OK;
  }
}

sub do_request {
  my $r = shift;
  my $response = HTTP::Tiny->new->get('https://www.google.com');
  $r->variable("response", $response);
}

sub wait_request {
  my $r = shift;

  if (!$r->variable("response")) {
    $r->sleep(10, \&wait_request);
    return OK;
  } else {
    my $thr = threads->object($r->variable("thread"));
    $thr->detach();
    if (!Search::search($r->header_in("X-Entry"))) {
      $r->internal_redirect("/not-found");
      return OK;
    }
    $r->internal_redirect("/found");
  }

  return OK;
}

sub found {
  my $r = shift;
  $r->send_http_header("text/html");
  $r->status(200);
  $r->print("Found!");
  $r->rflush;
  return OK;
}

1;
__END__
