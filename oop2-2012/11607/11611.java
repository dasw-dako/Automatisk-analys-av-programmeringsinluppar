import java.util.*;

public class Person {

	private String namn;
	
	ArrayList<Vardesak> allaVardesaker = new ArrayList<Vardesak>();
	
	//konstruktor
	public Person (String n){
		namn=n;
	}
	
	//metod f�r att h�mta namn
	public String getNamn(){
		return namn;
	}
	
	// metod f�r att h�mta totalt v�rde i personens egen arraylist 
	public double getTotalVarde(){
		double totalSumma=0;
		for(Vardesak v : allaVardesaker){
			totalSumma=totalSumma + v.getVarde();
		}
		return totalSumma;
	}
	
	//metod f�r att l�gga till v�rdesaker
	public void addVardesaker(Vardesak v){
		allaVardesaker.add(v);
	}
	// en metod f�r b�rschkrach. v instanceof akterier visar att v �r en aktier och ingen annan v�rdesak och krasch() �r metoden som heter samma sak som ligger i klassen aktier. 
	public void b�rsKrasch(){
		for(Vardesak v : allaVardesaker)
			if (v instanceof Aktie)
				((Aktie) v).krasch();
	}
	
	public String getAllaVardesaker(){
		String vardesaker = "";
		for(Vardesak v : allaVardesaker)
			vardesaker = vardesaker + v.getVardesaksNamn()+" " + v.getVarde()+ " ";
		return vardesaker;
		
	}
	
	public String toString(){
		return namn;
	}
}

