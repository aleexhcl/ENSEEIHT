
public class ExpressionDefinie implements Expression {
	
	private AccesVariable  ident;
	private Expression expIdent;
	private Expression expSuite;

	public ExpressionDefinie(AccesVariable  i, Expression eident, Expression esuite) {
		this.ident = i;
		this.expIdent = eident;
		this.expSuite = esuite;
	}
	
	public AccesVariable getIdent() {
		return this.ident;
	}
	
	public Expression getExpressionIdent() {
		return this.expIdent;
	}
	
	public Expression getExpressionSuite() {
		return this.expSuite;
	}
	
	public <R> R accepter(VisiteurExpression<R> visiteur) {
		return visiteur.visiterExpressionDefinie(this);
	}
}
