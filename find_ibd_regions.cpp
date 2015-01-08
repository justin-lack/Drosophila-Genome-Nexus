#include <iostream>
#include <sstream>
#include <cstdlib>
#include <fstream>
#include <stdio.h>
#include <string.h>

using namespace std;			

class options {
	
public:
	int window_size;
	float cutoff ;
	int overlap ; 
	string fasta_1;
	string fasta_2;
	
	string ibd_file ; 
	string divergence_file ; 
	void parse_command_line(int argc, char *argv[] );  
	
};

// parse command line options
void options::parse_command_line(int argc, char *argv[])  {
	
	window_size = 500000;
	cutoff = .0005 ;
	overlap = 400000 ; 
	
	for (int i=1; i<argc; i++) {
		
		if ( strcmp(argv[i],"-c") == 0 ) {
			cutoff = atof(argv[++i]);
		}
		if ( strcmp(argv[i],"-o") == 0 ) {
			overlap = atoi(argv[++i]);
		}
		if ( strcmp(argv[i],"-w") == 0 ) {
			window_size = atoi(argv[++i]);
		}
		if ( strcmp(argv[i],"-1") == 0 ) {
			fasta_1 = argv[++i];
		}
		if ( strcmp(argv[i],"-2") == 0 ) {
			fasta_2 = argv[++i];
		}
		if ( strcmp(argv[i],"-i" ) == 0 ) { 
			ibd_file = argv[++i] ; 
		}
		if ( strcmp(argv[i],"-d" ) == 0 ) { 
			divergence_file = argv[++i] ; 
		}
	}
}

class chromosomes {
public:
	
	string Chr2L;
	string Chr2R;
	string Chr3L;
	string Chr3R;
	string ChrX;
	
	void read_fa_file ( string fasta_file ) ; 
};

void chromosomes::read_fa_file ( string fasta_file ) {
	
	ifstream fasta_input ( fasta_file.c_str() );
	while (fasta_input) {
		
		string fasta_header;
		getline(fasta_input, fasta_header);
		if (fasta_header == ">Chr2L" && Chr2L.empty() ) {
			getline(fasta_input, Chr2L);
		}
		else if (fasta_header == ">Chr2R" && Chr2R.empty() ) {
			getline(fasta_input, Chr2R);
		}
		else if (fasta_header == ">Chr3L" && Chr3L.empty() ) {
			getline(fasta_input, Chr3L);
		}
		else if (fasta_header == ">Chr3R" && Chr3R.empty() ) {
			getline(fasta_input, Chr3R);
		}
		else if (fasta_header == ">ChrX" && ChrX.empty() ) {
			getline(fasta_input, ChrX);
		}
	}
}

int calculate_divergence (string &chr_1, string &chr_2, options set, string chromosome) {
	
	if ( chr_1.empty() || chr_2.empty() ) return 0; 
	
	bool ibd = false ; 
	int ibd_start ; 
	
	ofstream ibd_out ( set.ibd_file.c_str(), ios::app );
	ofstream div_out ( set.divergence_file.c_str(), ios::app ) ; 
	
	for ( int win = 0 ; win < chr_1.size() ; win += set.window_size - set.overlap ) { 
		
		int bases_called_1 = 0 ;
		int bases_called_2 = 0 ;
		float bases_shared = 0 ;
		float divergence = 0 ;
		
		int high = win + set.window_size ; 
		if ( win + set.window_size > chr_1.size() ) { 
			high = chr_1.size() ;
		}
		if ( high - win < set.overlap ) break ; 
		
		for ( int i = win ; i < high ; i ++ ) { 
			
			if (chr_1.at(i) != 'N') {
				bases_called_1 ++;
			}
			if (chr_2.at(i) != 'N') {
				bases_called_2 ++;
				if (chr_1.at(i) != 'N') {
					bases_shared ++;
					if (chr_1.at(i) != chr_2.at(i)) {
						divergence ++;
					}
				}
			}
		}
		
		if ( ( divergence / bases_shared ) < set.cutoff ) {  
			if ( ibd == false ) { 
				ibd = true ; 
				ibd_start = win ; 
			}
		}
		else if ( divergence / bases_shared >= set.cutoff ) { 
			if ( ibd == true ) { 
				ibd_out << set.fasta_1 << "\t" << set.fasta_2 << "\t" << chromosome << "\t" << ibd_start << "\t" << win + set.window_size - ( set.window_size - set.overlap ) << endl ;
			}
			ibd = false ;
		}
		div_out << set.fasta_1 << "\t" << set.fasta_2 << "\t" << chromosome << "\t" << win << "\t" << high << "\t" << divergence / bases_shared << "\t" << set.cutoff << "\t" << ibd << endl  ; 
	}
		
	if ( ibd == true ) ibd_out << set.fasta_1 << "\t" << set.fasta_2 << "\t" << chromosome << "\t" << ibd_start << "\t" << chr_1.size() << endl ;
	
	ibd_out.close() ; 
	div_out.close() ; 
	
	return 1 ; 
}	


int main(int argc, char **argv) {  
	
	options set;
	set.parse_command_line(argc, argv);
	
	chromosomes fasta1;
	chromosomes fasta2;
	fasta1.read_fa_file( set.fasta_1 );
	fasta2.read_fa_file( set.fasta_2 );
	
	calculate_divergence (fasta1.Chr2L, fasta2.Chr2L, set, "Chr2L" );
	calculate_divergence (fasta1.Chr2R, fasta2.Chr2R, set, "Chr2R" );
	calculate_divergence (fasta1.Chr3L, fasta2.Chr3L, set, "Chr3L" );
	calculate_divergence (fasta1.Chr3R, fasta2.Chr3R, set, "Chr3R" );
	calculate_divergence (fasta1.ChrX, fasta2.ChrX, set, "ChrX" );
	
	return (0) ; 

}

