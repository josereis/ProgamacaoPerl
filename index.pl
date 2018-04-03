use strict;
use warnings;

# SUBROTINAS COMUNS A TODO O PROJETO
sub openFile {
	my $filename = shift; chomp $filename;
	open (my $f, '<', $filename) or die "Não foi possivel abrir o arquivo '$filename' $!";

	return $f;
}

sub closeFile {
	close(shift);
}

sub menu {
	#system("clear"); # LIMPAR O CONSOLE
	my $menu ="#############################################\n".
			  "#                   MENU                    #\n".
			  "#############################################\n".
			  "#                                           #\n".
			  "# 0 - Sair                                  #\n".
			  "# 1 - Palavras terminadas em vogal          #\n".
			  "# 2 - Numero de Capitulos do Livro          #\n".
			  "# 3 - Numero de Palavras Repetidas no Livro #\n".
			  "#                                           #\n".
			  "#############################################\n".
			  "Opcao: ";
	print $menu;
}

####################################
#  CONTADOR DE CAPITULOS DO LIVRO  #
####################################
sub NumberChaper {
	my $count = 0;
	my $filename = shift;
	
	my $file = openFile($filename); # ABRINDO ARQUIVO DO LIVRO AO QUAL SE FARAM OS LEVANTAMENTOS
	while (my $row = <$file>) {
		chomp $row; # REMOVE O CARACTER '\n'
		$row =~ s/\d+/ /g; # REMOVE TODOS OS DIGITOS/NUMEROS
		$row =~ s/[^a-zA-Z0-9]+/ /g; # CAPTURA TODAS AS PALAVRAS DA LINHA

		if($row =~ /^CHAPTER\s[A-Z]+/) {
			$count++;
		}
	}
	closeFile($file); # FEICHANDO O ARQUIVO REFERENETE AO LIVRO QUE SE DESEJA CAPTURAR AS INFORMAÇÕES;

	print "\n\nNumero de Capitulos do Livro: $count\n\n";
}

####################################
#  CONTADOR DE PALAVRAS REPETIDAS  #
####################################

sub NumberWordEq {
	my $filename = shift;

	my $count_of = {}; # CRIAÇÃO DE UM HASH PARA ARMAZENAR A QUANTIDADE QUE CADA PALAVRA SE REPETE NO ARQUIVO
	my $file = openFile($filename); # ABRINDO ARQUIVO DO LIVRO AO QUAL SE FARAM OS LEVANTAMENTOS
	while (my $row = <$file>) {
		chomp $row; # REMOVE O CARACTER '\n'
		$row =~ s/\d+/ /g; # REMOVE TODOS OS DIGITOS/NUMEROS
		$row =~ s/[^a-zA-Z0-9]+/ /g; # CAPTURA TODAS AS PALAVRAS DA LINHA

		$count_of->{$_}++ for (split /\s+/, lc $row); # PEGA CADA PALAVRA, SEPARADA PELO CARACTER DE " ", E VAI INCREMENTANDO O VALOR DE SUA APARIÇÃO.
	}
	closeFile($file); # FEICHANDO O ARQUIVO REFERENETE AO LIVRO QUE SE DESEJA CAPTURAR AS INFORMAÇÕES;

	system("clear");
	print "NUMERO DE PALAVRAS REPETIDAS:\n";
	for (sort {$count_of->{$b} <=> $count_of->{$a} } keys %{$count_of}) {
		print $_ . ': ' . $count_of->{$_} . " vezes.\n" if ($count_of->{$_} > 1);
	}
}

####################################
#   PALAVRAS TERMINADAS EM VOGAL   #
####################################
sub WordVogalFinal {
	my $filename = shift;

	my $file = openFile($filename); # ABRINDO ARQUIVO DO LIVRO AO QUAL SE FARAM OS LEVANTAMENTOS
	while (my $row = <$file>) {
		chomp $row; # REMOVE O CARACTER '\n'
		$row =~ s/\d+/ /g; # REMOVE TODOS OS DIGITOS/NUMEROS
		$row =~ s/[^a-zA-Z0-9]+/ /g; # CAPTURA TODAS AS PALAVRAS DA LINHA

		for(split /\s+/, $row) {
			print "$_\n" if $_ =~ /.+[aeiou]$/;
		}
	}
	closeFile($file); # FEICHANDO O ARQUIVO REFERENETE AO LIVRO QUE SE DESEJA CAPTURAR AS INFORMAÇÕES;
}
####################################
#               MAIN               #
####################################

system("clear");
print "Digite o nome do arquivo: "; my $filename = <>;

if($filename ne "") {
	#my $file = openFile($filename); # ABRINDO ARQUIVO DO LIVRO AO QUAL SE FARAM OS LEVANTAMENTOS

	while (1) {
		menu; my $op = <>; chomp $op; # FUNÇÃO QUE EXIBE O MENU DE PESQUISA E LENDO VALOR DIGITADO
		
		if($op eq "0") {
			print "Saindo ...\n"; last;
		} elsif ($op eq "1") {
			WordVogalFinal($filename);
		} elsif ($op eq "2") {
			NumberChaper($filename);
		} elsif ($op eq "3") {
			NumberWordEq($filename);
		} else {
			print "Opção invalida....Tente Novamente.\n";
		}
	}

#	closeFile($file); # FEICHANDO O ARQUIVO REFERENETE AO LIVRO QUE SE DESEJA CAPTURAR AS INFORMAÇÕES;
}