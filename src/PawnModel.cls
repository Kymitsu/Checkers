VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "PawnModel"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Option Base 0

Private prvRow As Integer       '/// VARIABLE PRIV�E : Ligne
Private prvColumn As Integer    '/// VARIABLE PRIV�E : Colonne
Private prvColor As EColor      '/// VARIABLE PRIV�E : Couleur
Private prvIsPawn As Boolean    '/// VARIABLE PRIV�E : est v�ritablement un pion
Private prvIsQueen As Boolean   '/// VARIABLE PRIV�E : est une dame



'/// CONSTRUCTEUR: m�thode appel� lors de l'instanciation de l'objet
'/// PARAM�TRE   : Aucun
'/// RETOUR      : Aucun
Private Sub class_Initialize()
    'on initialise les variables avec les valeurs de la cellule A1
    prvRow = 1
    prvColumn = 1
End Sub



'/// DESTRUCTEUR: m�thode appel� lors de la destruction de l'objet
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Aucun
Private Sub class_Terminate()
    
End Sub



'/// PROC�DURE  : param�tre tous les attributs du pion � partir d'une range
'/// PARAM�TRE  : Range
'/// RETOUR     : Aucun
Public Sub Build(ByVal cell As Range)
    
    prvRow = cell.Row
    prvColumn = cell.Column

    '/// On d�finit la variable priv�e de couleur du pion
    
    If cell.Font.Color = RGB(255, 255, 255) Then
        prvColor = EColor.White
    ElseIf cell.Font.Color = RGB(0, 0, 0) Then
        prvColor = EColor.Black
    End If
    
    '/// On d�finit si la cellule contient un pion
    
    If Not IsEmpty(cell) And (Me.Color = EColor.Black Or Me.Color = EColor.White) Then
        prvIsPawn = True
    Else
        prvIsPawn = False
    End If
    
    '/// On d�finit la variable priv�e d'�tat Dame du pion, si la valeur de la cellule est � alors c'est une dame
    
    If InStr(Chr(169), cell.Value) Then
        prvIsQueen = True
    Else
        prvIsQueen = False
    End If
    
End Sub



'/// PROPRI�T� : Retourne la colonne du pion
'/// PARAM�TRE : Aucun
'/// RETOUR    : Integer
Public Property Get Column() As Integer
    Column = prvColumn
End Property



'/// PROPRI�T� : Modifie la variable priv�e correspondant � la colonne
'/// PARAM�TRE : Integer
'/// RETOUR    : Aucun (Let)
Public Property Let Column(ByVal pColumn As Integer)
    prvColumn = pColumn
End Property



'/// PROPRI�T� : Retourne la ligne du pion
'/// PARAM�TRE : Aucun
'/// RETOUR    : Integer
Public Property Get Row() As Integer
    Row = prvRow
End Property



'/// PROPRI�T� : Modifie la variable priv�e correspondant � la ligne
'/// PARAM�TRE : Integer
'/// RETOUR    : Aucun (Let)
Public Property Let Row(ByVal pRow As Integer)
    prvRow = pRow
End Property



'/// PROPRI�T�  : Retourne la valeur de la range du pion
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Range
Public Property Get CurrentRange() As Range
    Set CurrentRange = Cells(prvRow, prvColumn)
End Property



'/// PROPRI�T�  : Modifie les variables priv�es correspondant � la ligne et � la colonne du pion
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Range
Public Property Let CurrentRange(ByVal pRange As Range)
    Me.Row = pRange.Row
    Me.Column = pRange.Column
End Property



'/// PROPRI�T�  : Retourne la couleur du pion
'/// PARAM�TRE  : Aucun
'/// RETOUR     : EColor
Public Property Get Color() As EColor
   Color = prvColor
End Property



'/// PROPRI�T�  : Change la couleur du pion
'/// PARAM�TRE  : EColor
'/// RETOUR     : Aucun
Public Property Let Color(ByVal pColor As EColor)
    
    prvColor = pColor
    
    Select Case pColor
        Case EColor.White
            CurrentRange.Font.Color = RGB(255, 255, 255)
        Case EColor.Black
            CurrentRange.Font.Color = RGB(0, 0, 0)
    End Select
    
End Property



'/// PROPRI�T�  : Retourne la couleur des pions �nnemis
'/// PARAM�TRE  : Aucun
'/// RETOUR     : EColor
Public Property Get EnemyColor() As EColor
    
    If Me.Color = EColor.White Then
        EnemyColor = EColor.Black
    ElseIf Me.Color = EColor.Black Then
        EnemyColor = EColor.White
    End If
    
End Property



'/// PROPRI�T�  : Retourne 1 si le pion est noir, -1 s'il est blanc
'///              Cela correspond � la direction selon Y (les lignes) vers laquelle le pion a le droit de se d�placer
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Integer
Public Property Get Orientation() As Integer
    
    If Me.Color = EColor.White Then
        Orientation = -1
    ElseIf Me.Color = EColor.Black Then
        Orientation = 1
    End If
    
End Property



'/// PROPRI�T�  : Retourne vrai si le pion est une Dame
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Boolean
Public Property Get IsQueen() As Boolean
    IsQueen = prvIsQueen
End Property



'/// PROPRI�T�  : Modifie la variable priv�e correspondant au rang du pion et le transforme en dame
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Boolean
Public Property Let IsQueen(ByVal pIsQueen As Boolean)
    
    prvIsQueen = pIsQueen
    
    If pIsQueen Then
        CurrentRange.Value = Chr(169)
    End If
    
End Property



'/// PROPRI�T�  : Retourne vrai si le pion est v�ritablement un pion
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Boolean
Public Property Get IsPawn() As Boolean
    IsPawn = prvIsPawn
End Property



'/// PROPRI�T�  : Modifie la variable priv�e correspondant � l'etat du pion
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Boolean
Public Property Let IsPawn(pIsPawn As Boolean)
    prvIsPawn = pIsPawn
End Property



'/// PROC�DURE  : Transforme le pion en dame s'il est sur la derni�re ligne de son orientation
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Aucun
Public Sub TryBecomeQueen()

    If Not IsQueen Then
        If Me.Color = EColor.Black And Me.Row = 9 Or _
           Me.Color = EColor.White And Me.Row = 2 Then
            Me.IsQueen = True
        End If
    End If
    
End Sub



'/// FONCTION   : V�rifie si le mouvement est autoris� et, si possible, d�place le pion.
'///              Retourne vrai si le pion peut se d�placer
'/// PARAM�TRE  : Pion (� la position finale apr�s d�placement), Boul�en indiquant si on d�place le pion
'/// RETOUR     : Boolean
Public Function TryMoveTo(ByVal pTarget As PawnModel, ByVal pDoMove As Boolean) As Boolean
    
    If Me.CanMoveTo(pTarget) Then
        TryMoveTo = True
        If pDoMove Then
            Call MoveTo(pTarget)
        End If
    End If
    
End Function



'/// PROC�DURE  : D�place le pion vers la position pass� en param�tre
'/// PARAM�TRE  : Pion (� la position finale apr�s d�placement)
'/// RETOUR     : Aucun
Public Sub MoveTo(ByVal pTarget As PawnModel)
Dim move As MoveModel

    Set move = New MoveModel
    Call move.Build(Me, pTarget)
    
    'si c'est une attaque
    If move.IsAttack Then
        'on efface le pion mang�
        move.EnemyKilled.CurrentRange.ClearContents
    End If
    
    'on efface le pion de sa position initial
    Me.CurrentRange.ClearContents
    'on associe la nouvelle range au pion
    Me.CurrentRange = pTarget.CurrentRange
    'on v�rifie si le pion peut devenir une dame
    Call Me.TryBecomeQueen
    'on imprime le pion sur le plateau � sa nouvelle position
    Call Me.PrintPawnOnBoard
    
End Sub



'/// PROPRI�T�  : V�rifie si le mouvement est autoris�
'/// PARAM�TRE  : Pion (� la position finale apr�s d�placement)
'/// RETOUR     : Boolean
Public Property Get CanMoveTo(ByVal pTarget As PawnModel) As Boolean
Dim move As MoveModel
    
    'on initialise le retour de la fonction a false
    CanMoveTo = False
    
    'on instancie un nouvel objet d�placement que l'on construit avec le pion actuel et le pion � la position finale souhait�
    Set move = New MoveModel
    Call move.Build(Me, pTarget)
    
    'si c'est un d�placement et aucun pion alli� ne peut attaquer ou que ce d�placement est une attaque
    If (move.IsMove And Not Me.HasAttackingAlly) Or move.IsAttack Then
        CanMoveTo = True
    End If
    
    
End Property



'/// PROPRI�T�  : Retourne true si le pion peut attaquer
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Boolean
Public Property Get CanAttack() As Boolean
Dim board As BoardModel
Dim targetCandidate As PawnModel
Dim move As MoveModel
Dim coefVector As Variant
Dim cardinalDirections As Variant
Dim cardinalDirection As Variant
Dim outOfRange As Boolean
Dim iVector As Integer
Dim nextRow As Integer
Dim nextColumn As Integer
Dim nextCell As Range
    
    'on initialise le retour de la fonction a false
    CanAttack = False
    
    Set targetCandidate = New PawnModel
    Set board = New BoardModel
    Set move = New MoveModel

    'si le pion est v�ritablement un pion
    If Me.IsPawn Then
    
        'on construit un tableau remplit des 4 directions possibles
        cardinalDirections = Array(EWindRose.NorthEast, EWindRose.NorthWest, EWindRose.SouthEast, EWindRose.SouthWest)
        
        'pour chaque direction possible dans le tableau des directions possible
        For Each cardinalDirection In cardinalDirections
        
            'on r�cup�re les coefficients associ�s � la direction du d�placement
            coefVector = board.CardinalCoef(cardinalDirection)
            
            iVector = 0
            outOfRange = False
            
            'si le pion est une dame
            If IsQueen Then
            
                'Tant qu�on n�a pas d�tecter un pion � manger ou la fin du plateau, on boucle
                While Not (outOfRange)
                
                    iVector = iVector + 1
                    
                    nextRow = Me.Row + iVector * coefVector(0)
                    nextColumn = Me.Column + iVector * coefVector(1)
                    
                    'on r�cup�re les coordonn�es de la ni�me cellule sur la diagonale
                    Set nextCell = Cells(nextRow, nextColumn)
                    
                    'si cellule sur damier
                    If board.GetSection(nextCell) = ESection.Game Then
                    
                        'on construit l'objet pion
                        Set targetCandidate = New PawnModel
                        Call targetCandidate.Build(nextCell)
                        
                        'si la case est vide et est pr�te a accueillir un d�placement
                        If Not targetCandidate.IsPawn Then
                            
                            'on construit un objet d�placement � partir du pion actuel et la cellule en cours de test comme destination de mouvement
                            Call move.Build(Me, targetCandidate)
                            
                            'si le d�placement est une attaque
                            If move.IsAttack Then
                            
                                CanAttack = True
                                
                                Exit Property
                                
                            End If
                         End If
                    'si cellule hors du damier
                    Else
                        outOfRange = True
                    End If
                Wend
            'si le pion n'est pas une dame
            Else
                
                nextRow = Me.Row + 2 * coefVector(0)
                nextColumn = Me.Column + 2 * coefVector(1)
                
                If nextRow > 0 And nextColumn > 0 Then
                
                    Set nextCell = Cells(nextRow, nextColumn)
                    
                    'si cellule sur damier
                    If board.GetSection(nextCell) = ESection.Game Then
                
                        'on construit l'objet pion
                        Set targetCandidate = New PawnModel
                        Call targetCandidate.Build(nextCell)
                        
                        'si la case est vide et est pr�te � accueillir un d�placement
                        If Not targetCandidate.IsPawn Then
                            
                            'on construit un objet d�placement � partir du pion actuel et la cellule en cours de test comme destination de mouvement
                            Call move.Build(Me, targetCandidate)
                            
                            'si le d�placement est une attaque
                            If move.IsAttack Then
                            
                                CanAttack = True
                                
                                Exit Property
                                
                            End If
                         End If
                    End If
                End If
            End If
        Next cardinalDirection
    End If
    
End Property



'/// PROPRI�T�  : Retourne true si le pion peut se d�placer
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Boolean
Public Property Get CanMove() As Boolean
Dim move As MoveModel
Dim coefVector As Variant
Dim cardinalDirections As Variant
Dim cardinalDirection As Variant
Dim Row As Integer, Column As Integer
Dim nextCell As Range
Dim targetCandidate As PawnModel
Dim board As BoardModel

    'on initialise le retour de la fonction a false
    CanMove = False
    
    'si aucun alli� ne peut attaquer
    If Me.IsPawn And Not Me.HasAttackingAlly Then
    
        Set targetCandidate = New PawnModel
        Set board = New BoardModel
        Set move = New MoveModel
    
        'on construit un tableau remplit des 4 directions possibles
        cardinalDirections = Array(EWindRose.NorthEast, EWindRose.NorthWest, EWindRose.SouthEast, EWindRose.SouthWest)
        
        'pour chaque direction possible dans le tableau des directions possible
        For Each cardinalDirection In cardinalDirections
        
            'on r�cup�re les coefficients associ�s � la direction du d�placement
            coefVector = board.CardinalCoef(cardinalDirection)
            
            'si le pion est une dame
            'ou si on est en train de tester une direction au nord pour un pion blanc, sud pour un pion noir
            If Me.IsQueen Or coefVector(0) = Me.Orientation Then
        
                Row = Me.Row + 1 * coefVector(0)
                Column = Me.Column + 1 * coefVector(1)
                
                'on r�cup�re les coordonn�es de la ni�me cellule sur la diagonale
                Set nextCell = Cells(Row, Column)
                
                'si cellule sur damier
                If board.GetSection(nextCell) = ESection.Game Then
                
                    'on construit l'objet pion
                    Set targetCandidate = New PawnModel
                    Call targetCandidate.Build(nextCell)
                    
                    'si la case est vide et est pr�te � accueillir un d�placement
                    If Not targetCandidate.IsPawn Then
                        
                        'on construit un objet d�placement � partir du pion actuel et la cellule en cours de test comme destination de mouvement
                        Call move.Build(Me, targetCandidate)
                        
                        'si le d�placement est un mouvement
                        If move.IsMove Then
                        
                            CanMove = True
                            
                            Exit Property
                            
                        End If
                    End If
                End If
            End If
        Next cardinalDirection
    End If
            
End Property



'/// PROPRI�T�  : Retourne true si un alli� peut attaquer
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Boolean
Public Property Get HasAttackingAlly() As Boolean
Dim alliesPawn As Variant
Dim allyPawn As Variant
    
    'Set currentPawn = New PawnModel
    
    HasAttackingAlly = False
    
    'on r�cup�re le tableau des pions alli�s
    alliesPawn = Tools.GetPawns(Me.Color)
    
    'pour chaque pion alli� dans le tableau de pion alli�s
    For Each allyPawn In alliesPawn
        
        'si le pion alli� peut attaquer
        If allyPawn.CanAttack Then
        
            HasAttackingAlly = True
            Exit For
        End If
    Next allyPawn
End Property



'/// PROC�DURE  : �crit le pion sur le plateau
'/// PARAM�TRE  : Aucun
'/// RETOUR     : Aucun
Public Sub PrintPawnOnBoard()
        
    If Me.IsPawn And Me.IsQueen Then
        Me.CurrentRange.Value = Chr(169)
    ElseIf Me.IsPawn Then
        Me.CurrentRange.Value = "O"
    End If
    If Me.Color = EColor.White Then
        Me.CurrentRange.Font.Color = RGB(255, 255, 255)
    ElseIf Me.Color = EColor.Black Then
        Me.CurrentRange.Font.Color = RGB(0, 0, 0)
    End If
        
End Sub
