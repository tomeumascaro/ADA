--d_binarytree.ads
generic
   type item is private;
   first_item: item; -- element neutre del tipus item, si son nombres sera 0
   len: integer;
   with function "+"(a,b: in item) return item;
   with function "="(a,b: in item) return boolean;
   with function Image(a: in item) return String; --per imprimir items

package d_binarytree is

   type arbre is limited private;
   bad_use: exception;
   -- no pot haver mes procediments o funcions publiques
   procedure inserir(a: in out arbre; x: in item);
   function is_path_sum(a: in arbre; x: in item) return boolean;

private

   subtype rang is integer range 1..len;

   type mem is array (rang) of item;

   type arbre is --l'arbre es un array
      record
         m: mem;
         free: rang := rang'First; --primer node buid
      end record;

end d_binarytree;
