# mlops/evaluation.py
from nltk.translate.bleu_score import sentence_bleu, SmoothingFunction
from nltk.translate.meteor_score import meteor_score
from rouge_score import rouge_scorer

def evaluate_response(generated: str, reference: str) -> dict:
    """
    Avalia a qualidade da resposta gerada comparando com uma referência.
    Retorna métricas BLEU, ROUGE e METEOR.
    
    Args:
        generated (str): Texto gerado pelo modelo.
        reference (str): Texto de referência esperado.
    
    Returns:
        dict: métricas calculadas.
    """
    # BLEU
    smoothie = SmoothingFunction().method4
    bleu_score = sentence_bleu(
        [reference.split()],
        generated.split(),
        smoothing_function=smoothie
    )

    # ROUGE
    scorer = rouge_scorer.RougeScorer(["rouge1", "rouge2", "rougeL"], use_stemmer=True)
    rouge_scores = scorer.score(reference, generated)

    # METEOR
    meteor = meteor_score([reference.split()], generated.split())

    return {
        "BLEU": bleu_score,
        "ROUGE-1": rouge_scores["rouge1"].fmeasure,
        "ROUGE-2": rouge_scores["rouge2"].fmeasure,
        "ROUGE-L": rouge_scores["rougeL"].fmeasure,
        "METEOR": meteor
    }
