-- This Happy file was machine-generated by the BNF converter
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
module Parmich where
import Absmich
import Lexmich
import ErrM

}

%name pProgram Program
%name pStm Stm
%name pExp Exp

-- no lexer declaration
%monad { Err } { thenM } { returnM }
%tokentype { Token }

%token
  '!=' { PT _ (TS _ 1) }
  '&&' { PT _ (TS _ 2) }
  '(' { PT _ (TS _ 3) }
  ')' { PT _ (TS _ 4) }
  '*' { PT _ (TS _ 5) }
  '*=' { PT _ (TS _ 6) }
  '+' { PT _ (TS _ 7) }
  '++' { PT _ (TS _ 8) }
  '+=' { PT _ (TS _ 9) }
  ',' { PT _ (TS _ 10) }
  ', fun' { PT _ (TS _ 11) }
  '-' { PT _ (TS _ 12) }
  '--' { PT _ (TS _ 13) }
  '-=' { PT _ (TS _ 14) }
  '->' { PT _ (TS _ 15) }
  '/' { PT _ (TS _ 16) }
  '/=' { PT _ (TS _ 17) }
  ';' { PT _ (TS _ 18) }
  '<' { PT _ (TS _ 19) }
  '<=' { PT _ (TS _ 20) }
  '=' { PT _ (TS _ 21) }
  '==' { PT _ (TS _ 22) }
  '>' { PT _ (TS _ 23) }
  '>=' { PT _ (TS _ 24) }
  'bool' { PT _ (TS _ 25) }
  'else' { PT _ (TS _ 26) }
  'false' { PT _ (TS _ 27) }
  'for' { PT _ (TS _ 28) }
  'fun' { PT _ (TS _ 29) }
  'if' { PT _ (TS _ 30) }
  'int' { PT _ (TS _ 31) }
  'print' { PT _ (TS _ 32) }
  'return' { PT _ (TS _ 33) }
  'true' { PT _ (TS _ 34) }
  'while' { PT _ (TS _ 35) }
  '{' { PT _ (TS _ 36) }
  '||' { PT _ (TS _ 37) }
  '}' { PT _ (TS _ 38) }

L_ident  { PT _ (TV $$) }
L_integ  { PT _ (TI $$) }


%%

Ident   :: { Ident }   : L_ident  { Ident $1 }
Integer :: { Integer } : L_integ  { (read ( $1)) :: Integer }

Program :: { Program }
Program : ListExternal_declaration { Progr $1 } 


ListExternal_declaration :: { [External_declaration] }
ListExternal_declaration : External_declaration { (:[]) $1 } 
  | External_declaration ListExternal_declaration { (:) $1 $2 }


External_declaration :: { External_declaration }
External_declaration : Function_def { Afunc $1 } 
  | Dec { Global $1 }


Function_def :: { Function_def }
Function_def : Type_specifier Declarator Compound_stm { Func $1 $2 $3 } 


Dec :: { Dec }
Dec : Type_specifier Init_declarator ';' { Declarators $1 $2 } 


Init_declarator :: { Init_declarator }
Init_declarator : Declarator { OnlyDecl $1 } 
  | Declarator '=' Initializer { InitDecl $1 $3 }


Type_specifier :: { Type_specifier }
Type_specifier : 'bool' { Tbool } 
  | 'int' { Tint }


Declarator :: { Declarator }
Declarator : Ident { Name $1 } 
  | '(' Declarator ')' { ParenDecl $2 }
  | Ident '(' Parameter_declarations ')' { ParamFunDec $1 $3 }
  | Ident '(' ')' { FunDec $1 }


Parameter_declarations :: { Parameter_declarations }
Parameter_declarations : Type_declarations { OnlyTypes $1 } 
  | Declarations { OnlyVar $1 }
  | 'fun' Declarations { OnlyFun $2 }
  | Declarations ', fun' Declarations { VarAndFun $1 $3 }


Declarations :: { Declarations }
Declarations : Declaration { ParDec $1 } 
  | Declaration ',' Declarations { MoreParDec $1 $3 }


Declaration :: { Declaration }
Declaration : Type_specifier Declarator { TypeAndParam $1 $2 } 


Type_declarations :: { Type_declarations }
Type_declarations : Type_specifier { TypeDec $1 } 
  | Type_specifier ',' Type_declarations { MoreTypeDec $1 $3 }


Initializer :: { Initializer }
Initializer : Exp2 { InitExpr $1 } 


Return_stm :: { Return_stm }
Return_stm : 'return' Exp ';' { Sret $2 } 


Stm :: { Stm }
Stm : Compound_stm { CompS $1 } 
  | Expression_stm { ExprS $1 }
  | Selection_stm { SelS $1 }
  | Iter_stm { IterS $1 }
  | Print_stm { PrintS $1 }


Compound_stm :: { Compound_stm }
Compound_stm : '{' '}' { ScompOne } 
  | '{' Stms '}' { ScompTwo $2 }
  | '{' ListExternal_declaration '}' { ScompThree $2 }
  | '{' ListExternal_declaration Stms '}' { ScompFour $2 $3 }


Expression_stm :: { Expression_stm }
Expression_stm : ';' { SexprOne } 
  | Exp ';' { SexprTwo $1 }


Selection_stm :: { Selection_stm }
Selection_stm : 'if' '(' Exp ')' Compound_stm { SselIf $3 $5 } 
  | 'if' '(' Exp ')' Compound_stm 'else' Compound_stm { SselIfElse $3 $5 $7 }


Iter_stm :: { Iter_stm }
Iter_stm : 'while' '(' Exp ')' Stm { SiterWhile $3 $5 } 
  | 'for' '(' Expression_stm Expression_stm Exp ')' Stm { SiterFor $3 $4 $5 $7 }


Print_stm :: { Print_stm }
Print_stm : 'print' '(' Exp ')' ';' { Sprint $3 } 


Stms :: { Stms }
Stms : Return_stm { StmsRetOnly $1 } 
  | ListStm Return_stm { StmsRet $1 $2 }
  | ListStm { StmsNoRet $1 }


ListStm :: { [Stm] }
ListStm : Stm { (:[]) $1 } 
  | Stm ListStm { (:) $1 $2 }


Exp :: { Exp }
Exp : Exp ',' Exp2 { Ecomma $1 $3 } 
  | Exp2 { $1 }


Exp2 :: { Exp }
Exp2 : Exp9 Assignment_op Exp2 { Eassign $1 $2 $3 } 
  | Exp3 { $1 }


Exp3 :: { Exp }
Exp3 : Exp3 '||' Exp4 { Elor $1 $3 } 
  | Exp4 { $1 }


Exp4 :: { Exp }
Exp4 : Exp4 '&&' Exp6 { Eland $1 $3 } 
  | Exp5 { $1 }


Exp5 :: { Exp }
Exp5 : Exp5 '==' Exp6 { Eeq $1 $3 } 
  | Exp5 '!=' Exp6 { Eneq $1 $3 }
  | Exp6 { $1 }


Exp6 :: { Exp }
Exp6 : Exp6 '<' Exp7 { Elthen $1 $3 } 
  | Exp6 '>' Exp7 { Egrthen $1 $3 }
  | Exp6 '<=' Exp7 { Ele $1 $3 }
  | Exp6 '>=' Exp7 { Ege $1 $3 }
  | Exp7 { $1 }


Exp7 :: { Exp }
Exp7 : Exp7 '+' Exp8 { Eplus $1 $3 } 
  | Exp7 '-' Exp8 { Eminus $1 $3 }
  | Exp8 { $1 }


Exp8 :: { Exp }
Exp8 : Exp8 '*' Exp9 { Etimes $1 $3 } 
  | Exp8 '/' Exp9 { Ediv $1 $3 }
  | Exp9 { $1 }


Exp9 :: { Exp }
Exp9 : '++' Exp9 { Epreinc $2 } 
  | '--' Exp9 { Epredec $2 }
  | Exp10 { $1 }


Exp10 :: { Exp }
Exp10 : Exp10 '++' { Epostinc $1 } 
  | Exp10 '--' { Epostdec $1 }
  | Exp11 { $1 }


Exp11 :: { Exp }
Exp11 : '(' Parameter_declarations ')' '->' Stm { Elambda $2 $5 } 
  | Exp12 { $1 }


Exp12 :: { Exp }
Exp12 : Exp12 '(' ')' { Efunk $1 } 
  | Exp12 '(' ListExp2 ')' { Efunkpar $1 $3 }
  | Exp13 { $1 }


Exp13 :: { Exp }
Exp13 : Ident { Evar $1 } 
  | Constant { Econst $1 }
  | '(' Exp ')' { $2 }


Constant :: { Constant }
Constant : Integer { Eint $1 } 
  | 'true' { Etrue }
  | 'false' { Efalse }


ListExp2 :: { [Exp] }
ListExp2 : Exp2 { (:[]) $1 } 
  | Exp2 ',' ListExp2 { (:) $1 $3 }


Assignment_op :: { Assignment_op }
Assignment_op : '=' { Assign } 
  | '*=' { AssignMul }
  | '/=' { AssignDiv }
  | '+=' { AssignAdd }
  | '-=' { AssignSub }



{

returnM :: a -> Err a
returnM = return

thenM :: Err a -> (a -> Err b) -> Err b
thenM = (>>=)

happyError :: [Token] -> Err a
happyError ts =
  Bad $ "syntax error at " ++ tokenPos ts ++ 
  case ts of
    [] -> []
    [Err _] -> " due to lexer error"
    _ -> " before " ++ unwords (map (id . prToken) (take 4 ts))

myLexer = tokens
}

