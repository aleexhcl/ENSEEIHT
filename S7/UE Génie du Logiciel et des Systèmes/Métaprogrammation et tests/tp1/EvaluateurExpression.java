import java.util.HashMap;

public class EvaluateurExpression implements VisiteurExpression<Integer> {
	
	private HashMap<String, Integer> environnement;
	private Integer opG, opD;
	public Exception VariableException;
	
	public EvaluateurExpression(HashMap<String, Integer> e) {
		this.environnement = e;
	}

	public Integer visiterAccesVariable(AccesVariable v) throws VariableException {
		Integer nom = this.environnement.get(v.getNom());
		if (nom == null) {
			throw new VariableException("pas de variable dans l'environnement");
		}
		return nom;
	}

	public Integer visiterConstante(Constante c) {
		return Integer.valueOf(c.getValeur());
	}

	public Integer visiterExpressionBinaire(ExpressionBinaire e) {
		Integer opGcalc = e.getOperandeGauche().accepter(this);
		Integer opDcalc = e.getOperandeDroite().accepter(this);
		
		this.opD = opDcalc;
		this.opG = opGcalc;
		
		return e.getOperateur().accepter(this);
			
	}

	public Integer visiterAddition(Addition a) {
		return opG + opD;
	}

	public Integer visiterMultiplication(Multiplication m) {
		return opG * opD;
	}

	public Integer visiterExpressionUnaire(ExpressionUnaire e) {
		opG = e.getOperande().accepter(this);
		return e.getOperateur().accepter(this);
	}

	public Integer visiterNegation(Negation n) {
		return - opG;
	}

	@Override
	public Integer visiterSoustraction(Soustraction s) {
		// TODO Auto-generated method stub
		return opG - opD;
	}
}
