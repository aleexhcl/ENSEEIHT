with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;

-- Lecteurs concurrents, approche automate. Pas de politique d'accès.
package body LR.Synchro.Basique2 is

   function Nom_Strategie return String is
   begin
      return "serveur, lecteurs concurrents, sans politique d'accès";
   end Nom_Strategie;

   task LectRedTask is
      entry Demander_Lecture;
      entry Demander_Ecriture;
      entry Terminer_Lecture;
      entry Terminer_Ecriture;
   end LectRedTask;

   task body LectRedTask is
        lecture : Boolean := False;
        ecriture : Boolean := False;
   begin
      loop

      -- TODO

         select
         when (not lecture and not ecriture) =>
            accept Demander_Lecture ; lecture := True;
         or when (not lecture and not ecriture) =>
            accept Demander_Ecriture ; ecriture := True;
         or when lecture =>
            accept Terminer_Lecture ; lecture := False;
         or when ecriture =>
            accept Terminer_Ecriture ; ecriture := False;

         end select;
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

end LR.Synchro.Basique2;
