with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;

-- Lecteurs concurrents, approche automate. Pas de politique d'accès.
package body LR.Synchro.Basique is
   
   function Nom_Strategie return String is
   begin
      return "Automate, lecteurs concurrents, sans politique d'accès";
   end Nom_Strategie;
   
   task LectRedTask is
      entry Demander_Lecture;
      entry Demander_Ecriture;
      entry Terminer_Lecture;
      entry Terminer_Ecriture;
   end LectRedTask;

   type EtatLectRed is (Lecture, Ecriture, Attente);
   
   task body LectRedTask is
      etat : EtatLectRed := Attente;
   begin
      loop
      
      -- TODO
      
         case etat is 
         when Attente =>
            select
            accept Demander_Lecture ; etat := Lecture ;
            or accept Demander_Ecriture ; etat := Ecriture;
            end select; 
            
         when Lecture => 
            select 
            accept Terminer_Lecture ; etat := Attente;
            end select;
            
         when Ecriture =>
            select 
            accept Terminer_Ecriture ; etat := Attente;
            end select;
         
         end case;
      end loop;
   exception
      when Error: others =>
         Put_Line("**** LectRedTask: exception: " & Ada.Exceptions.Exception_Information(Error));
   end LectRedTask;

   procedure Demander_Lecture is
   begin
      LectRedTask.Demander_Lecture;
   end Demander_Lecture;

   procedure Demander_Ecriture is
   begin
      LectRedTask.Demander_Ecriture;
   end Demander_Ecriture;

   procedure Terminer_Lecture is
   begin
      LectRedTask.Terminer_Lecture;
   end Terminer_Lecture;

   procedure Terminer_Ecriture is
   begin
      LectRedTask.Terminer_Ecriture;
   end Terminer_Ecriture;

end LR.Synchro.Basique;
