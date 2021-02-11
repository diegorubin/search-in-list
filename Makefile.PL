use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'       => 'Search',
    'LIBS'       => [],
    'OBJECT' => 'search.o Search_wrap.o'
);
