use Search;

print("looking for: $ARGV[0]\n");
my $result = Search::search("$ARGV[0]");
if ($result) {
  print("found!");
} else {
  print("not found!");
}
