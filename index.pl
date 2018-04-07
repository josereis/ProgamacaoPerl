use strict;
use warnings;

# SUBROTINAS COMUNS A TODO O PROJETO
sub openFile {
	my $filename = shift; chomp $filename;
	open (my $f, '<', $filename) or die "Não foi possivel abrir o arquivo '$filename' $!";

	return $f;
}

sub saveFile {
	my ($filename, $data) = @_;
	open (my $f, '>', $filename) or die "Não foi possivel abrir o arquivo '$filename' $!";
		print $f "$data\n";

	close($f);
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
	system("echo -e 'Numero de Capitulos do Livro: '$count >> RELATORIO.txt");
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

	#system("clear");
	my $msg = "";
	for (sort {$count_of->{$b} <=> $count_of->{$a} } keys %{$count_of}) {
		$msg = $msg . $_ . ': ' . $count_of->{$_} . " vezes.\n" if ($count_of->{$_} > 1);
	}

	saveFile("PRepetidas.txt", $msg);
	system("echo 'Numero de Palavras Repetidas: '`cat PRepetidas.txt | wc -l` >> RELATORIO.txt");
}

####################################
#   PALAVRAS TERMINADAS EM VOGAL   #
####################################
sub WordVogalFinal {
	my $filename = shift;
	my $msg = "";
	my $file = openFile($filename); # ABRINDO ARQUIVO DO LIVRO AO QUAL SE FARAM OS LEVANTAMENTOS
	while (my $row = <$file>) {
		chomp $row; # REMOVE O CARACTER '\n'
		$row =~ s/\d+/ /g; # REMOVE TODOS OS DIGITOS/NUMEROS
		$row =~ s/[^a-zA-Z0-9]+/ /g; # CAPTURA TODAS AS PALAVRAS DA LINHA

		for(split /\s+/, $row) {
			$msg = $msg . lc "$_\n" if ($_ =~ /.+[aeiou]$/) and ($_ ne "") ;
		}
	}
	closeFile($file); # FEICHANDO O ARQUIVO REFERENETE AO LIVRO QUE SE DESEJA CAPTURAR AS INFORMAÇÕES;
	
	saveFile("PTVogal_Aux.txt", $msg);
	system("cat PTVogal_Aux.txt | sort -u > PTVogal.txt"); system("rm PTVogal_Aux.txt");
	system("echo 'Numero de Palavras repetidas no livro:'`cat PTVogal.txt | wc -l`");
	system("echo 'Numero de Palavras Terminadas em Vogal: '`cat PTVogal.txt | wc -l` >> RELATORIO.txt");
}

####################################
#               MAIN               #
####################################

#system("clear");
print "Digite o nome do arquivo: "; my $filename = <>;

if($filename ne "") {
	NumberChaper($filename);
	NumberWordEq($filename);
	WordVogalFinal($filename);

	print "FORAM CRIADOS 3 ARQUIVOS:\n";
	print "RELATORIO.txt - contendo o numero de Capitulos do Livro, o numero de Palavras Repetidas e o Numero de Palavras terminadas em Vogal;\n";
	print "PTVogal.txt - contem todas as palavras terminadas em vogal encontradas no Livro;\n";
	print "PRepetidas.txt - contem a frequecia que cada palavra apareceu no texto (no minimo 2 vezes\n).";

	print "\n\nTecle <ENTER> para encerrar!"; <>;
} else {
	print "O nome do arquivo não foi passado !!! Encenrrando o programa...\n"
}