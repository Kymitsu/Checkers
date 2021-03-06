VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "MoveModel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Option Base 0

Private prvPawn As PawnModel        '/// VARIABLE PRIV�E : Pion que l'on veut d�placer
Private prvTarget As PawnModel      '/// VARIABLE PRIV�E : Cible du d�placement
Private prvEnemyKilled As PawnModel '/// VARIABLE PRIV�E : Ennemi tu� lors du d�placement



'/// CONSTRUCTEUR: m�thode appel� lors de l'instanciation de l'objet
'/// PARAM�TRE   : Aucun
'/// RETOUR      : Aucun
Private Sub class_Initialize()
    
    'on instancie les variables priv�es pour pouvoir les manipuler dans les propri�t�s/fonctions/proc�dures
    Set prvPawn = New PawnModel
    Set prvTarget = New PawnModel
    Set prvEnemyKilled = New PawnModel
    
End Sub



'/// DESTRUCTEUR: m�thode appel� lors de la destruction de l'objet
'/// PARAM�TRE   : Aucun
'/// RETOUR      : Aucun
Private Sub class_Terminate()

    'on vide la m�moire associ�e aux variables priv�es
    Set prvPawn = Nothing
    Set prvTarget = Nothing
    Set prvEnemyKilled = Nothing
    
End Sub



'/// PROC�DURE  : Permet d'associer des valeurs aux variables priv�es
'/// PARAM�TRES : Pion , Pion �tat final
'/// RETOUR     : Aucun
Public Sub Build(ByVal pPawn As PawnModel, ByVal pTarget As PawnModel)
    
    'on associe des valeurs aux variables priv�es de notre objet 'move'
    Set prvPawn = pPawn
    Set prvTarget = pTarget
    
End Sub



'/// PROPRI�T�  : R�cup�re le d�placement suivant Y du mouvement (la diff�rence de ligne entre le pion et la cible)
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Integer
Private Property Get Yvector() As Integer
    Yvector = prvTarget.Row - prvPawn.Row
End Property



'/// PROPRI�T�  : R�cup�re le d�placement suivant X du mouvement (la diff�rence de colonne entre le pion et la cible)
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Integer
Private Property Get Xvector() As Integer
    Xvector = prvTarget.Column - prvPawn.Column
End Property



'/// PROPRI�T�  : R�cup�re la norme de d�placement du pion. La valeur sera 0 lorsque
'///              la cible ne sera pas positionn�e diagonalement par rapport au pion.
'///              Cette valeur repr�sente le nombre de case sur la diagonale s�parant
'///              la position initiale et finale du pion
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Integer
Private Property Get Norme() As Integer
    
    'on initialise la norme a 0
    Norme = 0
    
    'si la valeur absolue du d�placement sur x est �gale � la valeur absolue du d�placement sur y
    If Abs(Yvector) = Abs(Xvector) Then
        'alors le d�placement est sur une diagonale du pion
        Norme = Abs(Xvector)
    End If
    
End Property



'/// PROPRI�T�  : R�cup�re l'orientation du mouvement par rapport � son emplacement initial
'/// PARAM�TRE  : Aucun
'/// RETOUR     : La diagonale du mouvement
Public Property Get Direction() As EWindRose
    
    'si le signe du d�placement suivant X et suivant Y est positif
    If Sgn(Xvector) = 1 And Sgn(Yvector) = 1 Then
        'Alors le pion se d�place en direction du Sud Est (en bas � droite)
        Direction = EWindRose.SouthEast
        
    'si le signe du d�placement est positif suivant X et n�gatif suivant Y
    ElseIf Sgn(Xvector) = 1 And Sgn(Yvector) = -1 Then
        'Alors le pion se d�place en direction du Nord Est (en haut � droite)
        Direction = EWindRose.NorthEast
        
    'si le signe du d�placement est n�gatif suivant X et positif suivant Y
    ElseIf Sgn(Xvector) = -1 And Sgn(Yvector) = 1 Then
        'Alors le pion se d�place en direction du Sud-Ouest (en bas � gauche)
        Direction = EWindRose.SouthWest
        
    'si le signe du d�placement suivant X et suivant Y est n�gatif
    ElseIf Sgn(Xvector) = -1 And Sgn(Yvector) = -1 Then
        'Alors le pion se d�place en direction du Nord-Ouest (en haut � gauche)
        Direction = EWindRose.NorthWest
    End If
    
End Property



'/// PROPRI�T�  : R�cup�re le pion tu� lors du d�placement (=Nothing si aucun pion n'est mang� pendant le d�placement)
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Pion
Public Property Get EnemyKilled() As PawnModel
    Set EnemyKilled = prvEnemyKilled
End Property



'/// PROPRI�T�  : Retourne true si le d�placement correspond � un mouvement
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Bool�en
Public Property Get IsMove() As Boolean
    
    'on initialise le retour � false
    IsMove = False

    'si le pion est une dame
    If prvPawn.IsQueen Then
        If IsQueenMove() Then
            IsMove = True
        End If
   'si le pion n'est pas une dame
    Else
        'si le mouvement respect les r�gles du mouvement d'un pion
        If IsPawnMove() Then
            IsMove = True
        End If
    End If
       
End Property



'/// PROPRI�T�  : Retourne true si le d�placement correspond � une attaque
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Bool�en
Public Property Get IsAttack() As Boolean
    
    'on initialise le retour � false
    IsAttack = False
    
    'si le pion est une dame
    If prvPawn.IsQueen Then
        If IsQueenAttack() Then
            IsAttack = True
        End If
   'si le pion n'est pas une dame
    Else
        If IsPawnAttack() Then
            IsAttack = True
        End If
    End If
       
End Property



'/// PROPRI�T�  : Retourne true si le d�placement respecte les r�gles d'un mouvement de pion
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Bool�en
Public Property Get IsPawnMove() As Boolean
    
    'on initialise le retour � false
    IsPawnMove = False
    
    'si le d�placement n'est que d'une case,
    'et si le d�placement suivant Y est positif ( vers le bas ) si le pion est Noir, ou N�gatif (vers le haut) si le pion est blanc
    If Norme = 1 And Yvector = prvPawn.Orientation Then
        IsPawnMove = True
    End If
       
End Property



'/// PROPRI�T�  : Retourne true si le d�placement respecte les r�gles d'une attaque de pion
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Bool�en
Public Property Get IsPawnAttack() As Boolean
Dim enemyPawn As PawnModel
Dim enemyCell As Range

    'on initialise le retour � false
    IsPawnAttack = False
    
    'si le d�placement est de deux cases
    If Norme = 2 Then
        
        'on instancie un objet pion pour repr�senter le pion attaqu�
        Set enemyPawn = New PawnModel
        
        'on r�cup�re la cellule entre la position initiale et la position finale du pion
        Set enemyCell = Cells(prvTarget.Row - Sgn(Yvector) * 1, prvTarget.Column - Sgn(Xvector) * 1)
        
        'on construit un objet pion � partir de la cellule
        Call enemyPawn.Build(enemyCell)
        
        'si l'objet pion est v�ritablement un pion, et s'il n'est pas de la couleur du pion attaquant
        If enemyPawn.IsPawn And enemyPawn.Color = prvPawn.EnemyColor Then
        
            'on garde les informations du pion tu� dans la variable PRIV�E
            Set prvEnemyKilled = enemyPawn
            IsPawnAttack = True
            
        End If
        
    End If
       
End Property



'/// PROPRI�T�  : Retourne true si le d�placement respecte les r�gles de mouvement d'une Dame
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Bool�en
Public Property Get IsQueenMove() As Boolean
Dim outOfRange As Boolean
Dim maxVector As Integer
Dim coefVector As Variant       'repr�sente un tableau de (x,y) repr�sentant le coefficient a appliqu� pour cibler les cellules d'une diagonale
Dim nextCell As Range
Dim pawnCandidate As PawnModel
Dim board As BoardModel
    
    'on initialise le retour � false
    IsQueenMove = False
    
    'si le d�placement est sur la diagonale
    If Norme <> 0 Then
    
        'on instancie un objet pion
        Set pawnCandidate = New PawnModel
        'on instancie un objet plateau de jeu
        Set board = New BoardModel
        
        'on r�cup�re les coefficients associ�s � la direction du d�placement
        coefVector = board.CardinalCoef(Me.Direction)
        'on initialise le d�placement maximum possible a 0
        maxVector = 0
        
        outOfRange = False
        
        'Tant qu�on n�a pas d�tecter un pion � manger ou la fin du plateau, on boucle
        While Not outOfRange
            
            'on incr�mente de 1 la cellule maximal finale pour un potentiel d�placement
            maxVector = maxVector + 1
            
            'on r�cup�re les coordonn�es de la ni�me cellule sur la diagonale
            Set nextCell = Cells(prvPawn.Row + maxVector * coefVector(0), prvPawn.Column + maxVector * coefVector(1))
            
            'si cellule sur damier
            If board.GetSection(nextCell) = ESection.Game Then
            
                'on construit l'objet pion
                Call pawnCandidate.Build(nextCell)
                
                'si le pion existe
                If pawnCandidate.IsPawn Then
    
                    'cette case est la limite de notre d�placement
                    outOfRange = True
                        
                End If
                                
            'si cellule en dehors du damier
            Else
                outOfRange = True
                
            End If
            
        Wend
    
        'si le d�placement respecte la limite trouv�e
        If (Norme < maxVector) Then
        
            'le mouvement est accept�
            IsQueenMove = True
        End If
    
    End If
    
End Property



'/// PROPRI�T�  : Retourne true si le d�placement respecte les r�gles d'une attaque d'une dame
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Bool�en
Public Property Get IsQueenAttack() As Boolean
Dim outOfRange As Boolean
Dim iVector As Integer
Dim minVector As Integer
Dim maxVector As Integer
Dim coefVector As Variant       'repr�sente un tableau de (x,y) repr�sentant le coefficient a appliqu� pour cibler les cellules d'une diagonale
Dim nextCell As Range
Dim pawnCandidate As PawnModel
Dim pawnEnemy As PawnModel
Dim board As BoardModel
    
    Set pawnCandidate = New PawnModel
    Set pawnEnemy = New PawnModel
    Set board = New BoardModel
    
    'on initialise le retour � false
    IsQueenAttack = False
    
    'si le d�placement est sur la diagonale
    If Norme <> 0 Then
    
        'on r�cup�re les coefficients associ�s � la direction du d�placement
        coefVector = board.CardinalCoef(Me.Direction)
        'on initialise le d�placement minimum possible a 0
        minVector = 0
        'on initialise le d�placement maximum possible a 0
        maxVector = 0
        
        iVector = 0
        
        outOfRange = False
        
        'Tant qu�on n�a pas d�tecter un pion � manger ou la fin du plateau, on boucle
        While Not outOfRange
            
            'on incr�mente le vecteur repr�sentant la ni�me cellule sur la diagonal
            iVector = iVector + 1
            
            'on r�cup�r� les coordonn�es de la ni�me cellule sur la diagonale
            Set nextCell = Cells(prvPawn.Row + iVector * coefVector(0), prvPawn.Column + iVector * coefVector(1))
            
            'si cellule sur damier
            If board.GetSection(nextCell) = ESection.Game Then
            
                'on construit l'objet pion
                Call pawnCandidate.Build(nextCell)
                
                'si le pion existe
                If pawnCandidate.IsPawn Then
                    
                    'si un pion ennemi est m�moris�
                    If pawnEnemy.IsPawn Then
                        
                        'alors deux pions sont d�tect� et on ne peut se d�placer qu'entre eux, cette case est la limite de notre d�placement
                        outOfRange = True
                        maxVector = iVector
                        
                    'si aucun pion n'est m�moris�
                    Else
                    
                        'si le pion d�tect� est un pion ennemi
                        If pawnCandidate.Color = prvPawn.EnemyColor Then
                            
                            'on l'enregistre
                            Call pawnEnemy.Build(pawnCandidate.CurrentRange)

                            'notre d�placement commence � partir de cette case
                            minVector = iVector
                        
                        'si c'est un pion de notre couleur
                        Else
                            
                            'alors aucune attaque n'est possible
                            minVector = iVector
                            maxVector = iVector
                            outOfRange = True
                            
                        End If
                            
                    End If
                        
                's�il n'y pas de pion sur cette case
                Else
                
                    'si un pion ennemi est m�moris�
                    If pawnEnemy.IsPawn Then
                    
                        'on consid�re que la cellule actuelle est un emplacement valide de d�placement apr�s attaque
                        maxVector = iVector
                    
                    End If
                    
                End If
                                
            'si cellule en dehors du damier
            Else
                outOfRange = True
                maxVector = iVector
            End If
            
        Wend
        
        'si le d�placement est compris entre les limites trouv�
        If (Norme < maxVector) And (Norme > minVector) And pawnEnemy.IsPawn Then
            
            'l'attaque est valide
            IsQueenAttack = True
            
            'on enregistre le pion captur�
            prvEnemyKilled.CurrentRange = pawnEnemy.CurrentRange
            
        End If
        
    End If
            
End Property
