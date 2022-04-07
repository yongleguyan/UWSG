function bellhop( filename )
runbellhop = which( 'bellhop.exe' );
eval( [ '! "' runbellhop '" ' filename ] );
end