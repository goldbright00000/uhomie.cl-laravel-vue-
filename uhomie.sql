{\rtf1\ansi\ansicpg1252\cocoartf1561\cocoasubrtf600
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 -- phpMyAdmin SQL Dump\
-- version 4.9.0.1\
-- https://www.phpmyadmin.net/\
--\
-- Host: localhost:3306\
-- Generation Time: Feb 14, 2020 at 04:02 PM\
-- Server version: 5.7.26\
-- PHP Version: 7.3.7\
\
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";\
SET time_zone = "+00:00";\
\
--\
-- Database: `uhomie`\
--\
\
DELIMITER $$\
--\
-- Procedures\
--\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_conditions_score` (IN `Uwarranty` INT, IN `Uadvancement` INT, IN `Utime` INT, IN `Swarranty1` INT, IN `Swarranty2` INT, IN `Swarranty3` INT, IN `Sadvancement1` INT, IN `Sadvancement2` INT, IN `Sadvancement3` INT, IN `Stime1` INT, IN `Stime2` INT, IN `f1` VARCHAR(1000), IN `f2` VARCHAR(1000), IN `f3` VARCHAR(1000), IN `f4` VARCHAR(1000), IN `f5` VARCHAR(1000), IN `f6` VARCHAR(1000), IN `f7` VARCHAR(1000), IN `f8` VARCHAR(1000), INOUT `f` VARCHAR(10000), OUT `points` INT)  BEGIN\
    SET points = 0;\
\
    if (Uwarranty = 1) then\
        SET points = points + Swarranty1;\
        SET f = CONCAT(f,'/',f1);\
    end if;\
    if (Uwarranty = 2 ) then\
        SET points = points + Swarranty2;\
        SET f = CONCAT(f,'/',f2);\
    end if;\
    if (Uwarranty > 2) then\
        SET points = points + Swarranty3;\
    end if;\
\
    if (Uadvancement = 1) then\
        SET points = points + Sadvancement1;\
        SET f = CONCAT(f,'/',f4);\
    end if;\
    if (Uadvancement = 2 ) then\
        SET points = points + Sadvancement2;\
        SET f = CONCAT(f,'/',f5);\
    end if;\
    if (Uadvancement > 2) then\
        SET points = points + Sadvancement3;\
    end if;\
\
    if (Utime < 12) then\
        SET points = points + Stime1;\
        SET f = CONCAT(f,'/',f7);\
    end if;\
    if (Utime >= 2 ) then\
        SET points = points + Stime2;\
    end if;\
\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_contact_score_user` (IN `has_phone` BOOL, IN `has_mail` BOOL, IN `score_phone` INT, IN `score_mail` INT, IN `f1` VARCHAR(1000), IN `f2` VARCHAR(1000), OUT `total` INT, INOUT `f` VARCHAR(10000))  BEGIN\
\
    SET total = 0;\
    IF has_phone THEN\
       SET total = total + score_phone;\
    ELSE\
        SET f = CONCAT(f,'/',f1);\
    END IF;\
\
    IF has_mail THEN\
       SET total = total + score_mail;\
    ELSE\
        SET f = CONCAT(f,'/',f2);\
    END IF;\
\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_docs_user_score` (IN `Uuser_id` INT, IN `Ujob` INT, IN `SafpE` INT, IN `SafpF` INT, IN `SafpU` INT, IN `SdicomE` INT, IN `SdicomF` INT, IN `SdicomU` INT, IN `SotherF` INT, IN `SotherU` INT, IN `SsavesF` INT, IN `SsavesU` INT, IN `Sf_set` INT, IN `Ss_set` INT, IN `St_set` INT, IN `Swork` INT, IN `Slast` INT, IN `f2` VARCHAR(1000), IN `f3` VARCHAR(1000), IN `f4` VARCHAR(1000), IN `f5` VARCHAR(1000), IN `f6` VARCHAR(1000), IN `f7` VARCHAR(1000), IN `f9` VARCHAR(1000), IN `f10` VARCHAR(1000), IN `f11` VARCHAR(1000), IN `f12` VARCHAR(1000), IN `f13` VARCHAR(1000), IN `f15` VARCHAR(1000), IN `f16` VARCHAR(1000), IN `f17` VARCHAR(1000), IN `f18` VARCHAR(1000), INOUT `f` VARCHAR(10000), OUT `points` INT)  BEGIN\
\
    DECLARE done bool DEFAULT false;\
    DECLARE Dval bool DEFAULT false;\
    DECLARE Dname varchar(60) DEFAULT '';\
    DECLARE Dfactor integer DEFAULT 0;\
    DECLARE Dval_date boolean DEFAULT 0;\
\
    DECLARE docs CURSOR FOR\
            SELECT name, factor, val_date,verified\
            FROM files\
            WHERE user_id = Uuser_id and verified;\
\
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;\
\
    /* recorrido de los documentos*/\
    SET points = 0;\
    OPEN docs;\
    get_docs: LOOP\
    FETCH docs INTO Dname, Dfactor, Dval_date, Dval;\
\
    IF done  THEN\
        LEAVE get_docs;\
    else\
        CASE Ujob\
            WHEN 1 THEN\
                if Dname = 'afp' then\
                    if Dval_date = true and Dval = true then\
                        set points =  points + SafpE;\
                    else\
                        SET f = CONCAT(f,'/',f2);\
                    end if;\
                end if;\
                if Dname = 'dicom' and Dval = true then\
                    set points =  points + ((Dfactor*99)/999);\
                else\
                    SET f = CONCAT(f,'/',f3);\
                end if;\
                if Dname = 'first_settlement' and Dval = true then\
                    set points =  points + Sf_set;\
                else\
                    SET f = CONCAT(f,'/',f4);\
                end if;\
                if Dname = 'second_settlement' and Dval = true then\
                    set points =  points + Ss_set;\
                else\
                    SET f = CONCAT(f,'/',f5);\
                end if;\
                if Dname = 'third_settlement' and Dval = true then\
                    set points =  points + St_set;\
                else\
                    SET f = CONCAT(f,'/',f6);\
                end if;\
                if Dname = 'work_constancy' and Dval = true then\
                    set points =  points + Swork;\
                else\
                    SET f = CONCAT(f,'/',f7);\
                end if;\
            WHEN 2 THEN\
                if Dname = 'afp'   then\
                    if Dval_date = true and Dval = true then\
                        set points =  points + SafpF;\
                    else\
                        SET f = CONCAT(f,'/',f9);\
                    end if;\
                end if;\
                if Dname = 'dicom' and Dval = true then\
                    set points =  points + ((Dfactor*99)/999);\
                else\
                    SET f = CONCAT(f,'/',f10);\
                end if;\
\
                if Dname = 'other_income' and Dval = true then\
                    set points =  points + SotherF;\
                else\
                    SET f = CONCAT(f,'/',f11);\
                end if;\
                if Dname = 'last_invoice' and Dval = true then\
                    set points =  points + Slast;\
                else\
                    SET f = CONCAT(f,'/',f12);\
                end if;\
                if Dname = 'saves' and Dval = true then\
                    set points =  points + SsavesF;\
                else\
                    SET f = CONCAT(f,'/',f13);\
                end if;\
            WHEN 3 THEN\
                if Dname = 'afp' then\
                    if Dval_date = true and Dval = true then\
                        set points =  points + SafpU;\
                    else\
                        SET f = CONCAT(f,'/',f15);\
                    end if;\
                end if;\
                if Dname = 'dicom' and Dval = true then\
                    set points =  points + ((Dfactor*99)/999);\
                else\
                    SET f = CONCAT(f,'/',f16);\
                end if;\
                if Dname = 'other_income' and Dval = true then\
                    set points =  points + SotherU;\
                else\
                    SET f = CONCAT(f,'/',f17);\
                end if;\
                if Dname = 'saves' and Dval = true then\
                    set points =  points + SsavesU;\
                else\
                        SET f = CONCAT(f,'/',f18);\
                end if;\
        END CASE;\
    END IF;\
END LOOP get_docs;\
CLOSE docs;\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_endorsement_score_user` (IN `confirmed` BOOL, IN `confirmed_points` INT, IN `unconfirmed_points` INT, IN `Uinsurance` BOOLEAN, IN `Sinsurance` INT, IN `f1` VARCHAR(1000), IN `f2` VARCHAR(1000), INOUT `f` VARCHAR(10000), OUT `points` INT)  BEGIN\
    IF confirmed THEN\
        SET points = confirmed_points;\
    ELSE\
        SET points = unconfirmed_points;\
        SET f = CONCAT(f,'/',f1);\
    END IF;\
    IF Uinsurance THEN\
        SET points = points + Sinsurance;\
    ELSE\
        SET f = CONCAT(f,'/',f2);\
    END IF;\
\
\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_finantial_user_score` (IN `type_empl` INT, IN `rent` INT, IN `amount` INT, IN `save` INT, IN `other` INT, IN `last_invo` INT, IN `points` INT, IN `f1` VARCHAR(1000), INOUT `f` VARCHAR(10000), OUT `total` INT)  BEGIN\
\
    DECLARE summary float default 0;\
    SET total = 0;\
    CASE type_empl\
        WHEN 1 THEN\
            SET summary = amount + save/12 + other;\
        WHEN 2 THEN\
            SET summary = last_invo + save/12 + other;\
        WHEN 3 THEN\
            SET summary =  save/12 + other;\
        ELSE SET summary = 0;\
    END CASE;\
    SET summary = summary *.35;\
    if summary >= rent then\
        SET total = points;\
    else\
        SET total = points*(summary/rent);\
        SET f = CONCAT(f,'/',f1);\
    end if;\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_identity_user_score` (IN `Uuser_id` INT, IN `Sdni_o` INT, IN `Sdni_r` INT, IN `f1` VARCHAR(1000), IN `f2` VARCHAR(1000), OUT `points` INT, INOUT `f` VARCHAR(10000))  BEGIN\
    DECLARE Dfront varchar(60) DEFAULT '';\
    DECLARE Dback varchar(60) DEFAULT '';\
\
    SET Dfront = (SELECT name  FROM files   WHERE   user_id = Uuser_id and  verified and name = 'id_front');\
    SET Dback = (SELECT name   FROM files   WHERE   user_id = Uuser_id and  verified and name = 'id_back');\
    SET points = 0;\
\
    IF Dfront IS NULL  THEN\
        SET f = CONCAT(f,'/',f1);\
    else\
        set points =  points + Sdni_o;\
    END IF;\
\
    if Dback IS NULL then\
        SET f = CONCAT(f,'/',f2);\
    else\
        set points =  points + Sdni_r;\
    end if;\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_job_user_score` (IN `employment_type` INT, IN `employe_point` INT, IN `free_points` INT, IN `unemploye_point` INT, IN `fi` VARCHAR(1000), IN `f2` VARCHAR(1000), IN `f3` VARCHAR(1000), INOUT `f` VARCHAR(10000), OUT `points` INT)  BEGIN\
\
    IF(employment_type IS NULL) then\
        SET points =0;\
        SET f = CONCAT(f,'/',f3);\
    else\
        CASE employment_type\
            WHEN 1 THEN\
                SET points = employe_point;\
            WHEN 2 THEN\
                SET points = free_points;\
            WHEN 3 THEN\
                SET points = unemploye_point;\
            ELSE\
                SET points = 0;\
                SET f = CONCAT(f,'/',f3);\
        END CASE;\
    end if;\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_membership_user_score` (IN `user_id` VARCHAR(20), IN `basic_points` INT, IN `select_points` INT, IN `prime_points` INT, IN `f1` VARCHAR(1000), IN `f2` VARCHAR(1000), IN `f3` VARCHAR(1000), INOUT `f` VARCHAR(10000), OUT `points` INT)  BEGIN\
\
    DECLARE member varchar(20) DEFAULT '';\
    SET points = 0;\
    SET member = (select  c.name  from\
                users as a,\
                users_has_memberships as b,\
                memberships as c,\
                roles as d\
        where\
                a.id = user_id and\
                a.id = b.user_id and\
                b.membership_id = c.id and\
                d.id =c.role_id and\
                d.name = 'Arrendatario');\
        IF(member IS NULL) then\
            SET points = 0;\
            SET f = CONCAT(f,'/',f1);\
        end if;\
        IF(member = 'Basic') then\
            SET points = basic_points;\
            SET f = CONCAT(f,'/',f1);\
        end if;\
        IF(member = 'Select') then\
            SET points = select_points;\
            SET f = CONCAT(f,'/',f2);\
        end if;\
        IF(member = 'Premium') then\
            SET points = prime_points;\
\
        end if;\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_nationality_score_user` (IN `country` INT, IN `origin` INT, IN `document` VARCHAR(20), IN `national_u` INT, IN `rut` INT, IN `provisional` INT, IN `pass` INT, IN `f1` VARCHAR(1000), IN `f2` VARCHAR(1000), IN `f3` VARCHAR(1000), IN `f4` VARCHAR(1000), INOUT `f` VARCHAR(10000), OUT `points` INT)  BEGIN\
    SET points = 0;\
    if origin = country  then\
        SET points = national_u;\
    else\
        IF (document IS NULL) then\
            SET f = CONCAT(f,'/',f3);\
        else\
            if document = 'RUT_PROVISIONAL' then\
                SET points = provisional;\
            else\
                if document = 'PASAPORTE' then\
                    SET points = pass;\
                else\
                    if document = 'RUT' then\
                        SET points = rut;\
                    else\
                        SET f = CONCAT(f,'/',f3);\
                    end if;\
                end if;\
            end if;\
        end if;\
    end if;\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_preferences_score` (IN `Spro_type` INT, IN `Spro_for` INT, IN `Sdate` INT, IN `Spet` INT, IN `Ssmock` INT, IN `Upet` VARCHAR(20), IN `Ppet` VARCHAR(20), IN `Usmock` BOOL, IN `Psmock` BOOL, IN `Utype` INT, IN `Ptype` INT, IN `Udate` DATE, IN `Pdate` DATE, IN `user_id` INT, IN `property_id` INT, IN `f1` VARCHAR(1000), IN `f2` VARCHAR(1000), IN `f3` VARCHAR(1000), IN `f4` VARCHAR(1000), IN `f5` VARCHAR(1000), INOUT `f` VARCHAR(10000), OUT `sco` INT)  BEGIN\
\
    DECLARE value_id int;\
    SET sco= 0;\
\
    if Upet = Ppet then\
        set sco = sco + Spet;\
    ELSE\
        SET f = CONCAT(f,'/',f4);\
    end if;\
\
    if Usmock = Psmock then\
        set sco = sco + Ssmock;\
    ELSE\
        SET f = CONCAT(f,'/',f5);\
    end if;\
\
    if Utype = Ptype then\
        set sco = sco + Spro_type;\
    ELSE\
        SET f = CONCAT(f,'/',f1);\
    end if;\
\
    if Udate >= Pdate then\
        set sco = sco + Sdate;\
    ELSE\
        SET f = CONCAT(f,'/',f3);\
    end if;\
    set value_id =(select properties_has_properties_for.id\
        from    properties_has_properties_for,\
                users, properties\
        where\
            users.id = user_id and\
            properties.id = property_id and\
            properties.id =properties_has_properties_for.property_id and\
            users.property_for = properties_has_properties_for.property_for_id);\
\
    IF not (value_id IS NULL) then\
            set sco = sco + Spro_for;\
    ELSE\
        SET f = CONCAT(f,'/',f2);\
    end if;\
\
\
END$$\
\
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_score_user` (IN `user_id` INT, IN `property_id` INT)  BEGIN\
	DECLARE done int DEFAULT false;\
    /* 			contact function var 				*/\
    DECLARE score int(11) DEFAULT 0;\
    DECLARE Smail int(11) DEFAULT 0;\
    DECLARE Sphone int(11) DEFAULT 0;\
    DECLARE Umail bool;\
    DECLARE Uphone bool;\
    DECLARE Ucountry int(11) DEFAULT 0;\
    DECLARE Udocument varchar(20);\
    /* 			contact function var 					*/\
    DECLARE Sdni_o int(11) DEFAULT 0;\
    DECLARE Sdni_r int(11) DEFAULT 0;\
\
	/*		 	nationality_score_user vars 			*/\
\
	DECLARE Snational int(11) DEFAULT 0;\
	DECLARE Srut int(11) DEFAULT 0;\
    DECLARE Sprovitional int(11) DEFAULT 0;\
    DECLARE Spassport int(11) DEFAULT 0;\
	DECLARE country int(11) DEFAULT 0;\
	DECLARE nationality_score_user int(11) DEFAULT 0;\
	/* 			guarantor_score Vars 			*/\
	DECLARE Ucollateral_id int(11) DEFAULT 0;\
	DECLARE Sconfirmed int(11) DEFAULT 0;\
	DECLARE Sunconfirmed int(11) DEFAULT 0;\
	DECLARE Uconfirmed_collateral bool;\
	DECLARE guarantor_score int(11) DEFAULT 0;\
	DECLARE guarantor_confirmation_score int(11) DEFAULT 0;\
	DECLARE guarantor_identification_score int(11) DEFAULT 0;\
	DECLARE contact_guarantor_score int(11) DEFAULT 0;\
	DECLARE identity_guarantor_score int(11) DEFAULT 0;\
	DECLARE nationality_guarantor_score int(11) DEFAULT 0;\
    /* 			Categories Vars 			*/\
    DECLARE contact_user_score int(11) DEFAULT 0;\
    DECLARE identity_user_score int(11) DEFAULT 0;\
	DECLARE identification_score int(11) DEFAULT 0;\
	/* 			 socioeconomic_stability_score vars				*/\
	DECLARE Ujob int(11) DEFAULT 0;\
	DECLARE Semploy int(11) DEFAULT 0;\
	DECLARE SafpE int(11) DEFAULT 0;\
	DECLARE SdicomE int(11) DEFAULT 0;\
	DECLARE Sf_set int(11) DEFAULT 0;\
	DECLARE Ss_set int(11) DEFAULT 0;\
	DECLARE St_set int(11) DEFAULT 0;\
	DECLARE Swork int(11) DEFAULT 0;\
	DECLARE Sfree int(11) DEFAULT 0;\
	DECLARE SafpF int(11) DEFAULT 0;\
	DECLARE SdicomF int(11) DEFAULT 0;\
	DECLARE SotherF int(11) DEFAULT 0;\
	DECLARE SsavesF int(11) DEFAULT 0;\
	DECLARE Sinsurance int(11) DEFAULT 0;\
	DECLARE Slast int(11) DEFAULT 0;\
	DECLARE Sunemploy int(11) DEFAULT 0;\
	DECLARE SafpU int(11) DEFAULT 0;\
	DECLARE SdicomU int(11) DEFAULT 0;\
	DECLARE SotherU int(11) DEFAULT 0;\
	DECLARE SsavesU int(11) DEFAULT 0;\
	DECLARE Uinsurance boolean DEFAULT 0;\
	DECLARE job_type_score int(11) DEFAULT 0;\
	DECLARE job_docs_score int(11) DEFAULT 0;\
	DECLARE socioeconomic_stability_score int(11) DEFAULT 0;\
	/* preferences and conditions Vars*/\
	DECLARE preferences_score int(11) DEFAULT 0;\
	DECLARE conditions_score int(11) DEFAULT 0;\
	DECLARE preferences_conditions_score int(11) DEFAULT 0;\
\
	DECLARE Prent int(11) DEFAULT 0;\
	DECLARE Ppet varchar(30) DEFAULT 0;\
	DECLARE Psmock boolean DEFAULT 0;\
\
	DECLARE Ppro_type int(11) DEFAULT 0;\
	DECLARE Pdate date ;\
\
	DECLARE Upet varchar(30) DEFAULT 0;\
	DECLARE Usmock boolean DEFAULT 0;\
	DECLARE Upro_type int(11) DEFAULT 0;\
	DECLARE Udate date ;\
	DECLARE Uwarranty int DEFAULT 0;\
	DECLARE Uadvancement int DEFAULT 0;\
	DECLARE Utime int DEFAULT 0;\
\
	DECLARE Spro_type int DEFAULT 0;\
	DECLARE Spro_for int DEFAULT 0;\
	DECLARE Sdate int DEFAULT 0;\
	DECLARE Spet int DEFAULT 0;\
	DECLARE Ssmock int DEFAULT 0;\
	DECLARE Swarranty1 int DEFAULT 0;\
	DECLARE Swarranty2 int DEFAULT 0;\
	DECLARE Swarranty3 int DEFAULT 0;\
	DECLARE Sadvancement1 int DEFAULT 0;\
	DECLARE Sadvancement2 int DEFAULT 0;\
	DECLARE Sadvancement3 int DEFAULT 0;\
	DECLARE Stime1 int DEFAULT 0;\
	DECLARE Stime2 int DEFAULT 0;\
	/*  	memberships Vars  		 */\
	DECLARE Smembership1 int DEFAULT 0;\
	DECLARE Smembership2 int DEFAULT 0;\
	DECLARE Smembership3 int DEFAULT 0;\
	DECLARE membership_score int DEFAULT 0;\
	/*  	finantial Vars  		 */\
	DECLARE finantial_score int DEFAULT 0;\
	DECLARE Sfinantial int DEFAULT 0;\
	DECLARE Uamount int DEFAULT 0;\
	DECLARE Usave int DEFAULT 0;\
	DECLARE Uother int DEFAULT 0;\
	DECLARE Ulast int DEFAULT 0;\
	/* feedback Vars*/\
	DECLARE identification_feedback varchar(1000) DEFAULT '';\
	DECLARE guarantor_feedback varchar(1000) DEFAULT '';\
	DECLARE socioeconomic_stability_feedback varchar(1000) DEFAULT '';\
	DECLARE conditions_and_preferences_feedback varchar(1000) DEFAULT '';\
	DECLARE memberships_feedback varchar(1000) DEFAULT '';\
	DECLARE finantial_feedback varchar(1000) DEFAULT '';\
\
	DECLARE identification_details varchar(10000) DEFAULT '';\
	DECLARE guarantor_details varchar(10000) DEFAULT '';\
	DECLARE socioeconomic_stability_details varchar(10000) DEFAULT '';\
	DECLARE conditions_and_preferences_details varchar(10000) DEFAULT '';\
	DECLARE memberships_details varchar(10000) DEFAULT '';\
	DECLARE finantial_details varchar(10000) DEFAULT '';\
\
	DECLARE feedback1 varchar(1000) DEFAULT '';\
	DECLARE feedback2 varchar(1000) DEFAULT '';\
	DECLARE feedback3 varchar(1000) DEFAULT '';\
	DECLARE feedback4 varchar(1000) DEFAULT '';\
	DECLARE feedback5 varchar(1000) DEFAULT '';\
	DECLARE feedback6 varchar(1000) DEFAULT '';\
	DECLARE feedback7 varchar(1000) DEFAULT '';\
	DECLARE feedback8 varchar(1000) DEFAULT '';\
	DECLARE feedback9 varchar(1000) DEFAULT '';\
	DECLARE feedback10 varchar(1000) DEFAULT '';\
	DECLARE feedback11 varchar(1000) DEFAULT '';\
	DECLARE feedback12 varchar(1000) DEFAULT '';\
	DECLARE feedback13 varchar(1000) DEFAULT '';\
	DECLARE feedback14 varchar(1000) DEFAULT '';\
	DECLARE feedback15 varchar(1000) DEFAULT '';\
	DECLARE feedback16 varchar(1000) DEFAULT '';\
	DECLARE feedback17 varchar(1000) DEFAULT '';\
	DECLARE feedback18 varchar(1000) DEFAULT '';\
\
\
\
	/*			Cursor	  Arrendadores					*/\
    DECLARE lessor CURSOR FOR\
        SELECT  mail_verified,  phone_verified,\
                country_id, document_type,\
				collateral_id,  confirmed_collateral,\
				employment_type, move_date,\
				warranty_months_quantity,months_advance_quantity,\
				tenanting_months_quantity,property_type,\
				amount, save_amount,\
				other_income_amount, last_invoice_amount,\
				tenanting_insurance\
\
\
        FROM users\
        WHERE id = user_id;\
	/*	  			Cursor propiedades					*/\
	DECLARE property CURSOR FOR\
        SELECT 	rent, pet_preference,\
            	smoking_allowed, property_type_id,\
                available_date\
	    FROM properties\
        WHERE property_id=id;\
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;\
\
	/* SETEO feedback de Catgorias							*/\
	SET identification_feedback = (SELECT DISTINCT cat_feed FROM v_scoring\
					WHERE 	cat_id = 1);\
	SET guarantor_feedback=(	SELECT DISTINCT cat_feed FROM v_scoring\
					WHERE 	cat_id = 2);\
	SET socioeconomic_stability_feedback =(SELECT DISTINCT cat_feed FROM v_scoring\
					WHERE 	cat_id = 3);\
	SET conditions_and_preferences_feedback =(SELECT DISTINCT cat_feed	FROM v_scoring\
					WHERE 	cat_id = 4);\
	SET memberships_feedback =(SELECT DISTINCT cat_feed FROM v_scoring\
					WHERE 	cat_id = 5);\
	SET finantial_feedback =(SELECT DISTINCT cat_feed FROM v_scoring\
					WHERE 	cat_id = 6);\
\
\
	/* SETEO de Variables de Arrendador */\
    OPEN lessor;\
    get_lessor: LOOP\
        FETCH lessor INTO   Umail,Uphone,\
                            Ucountry, Udocument,\
							Ucollateral_id, Uconfirmed_collateral,\
							Ujob,Udate,\
							Uwarranty,Uadvancement,\
							Utime,Upro_type,\
							Uamount,Usave,\
							Uother, Ulast,\
							Uinsurance;\
        IF done  THEN\
            LEAVE get_lessor;\
        END IF;\
    END LOOP get_lessor;\
    CLOSE lessor;\
	/* SETEO de Variables de Propiedades */\
	OPEN property;\
	get_property: LOOP\
	FETCH property INTO Prent, Ppet,\
						Psmock, Ppro_type,\
						Pdate;\
\
		IF done  THEN\
			LEAVE get_property;\
		END IF;\
\
	END LOOP get_property;\
	CLOSE property;\
	/*---------------------------------------------------------------\
						CATEGORY = 1\
     identification_score  = 	contact_user_score +\
	 								nationality_score_user\
	---------------------------------------------------------------	*/\
\
	/*---------------------- contact_user_score---------------------*/\
\
\
	SET Sphone = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 1);\
	SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 1);\
    SET Smail = (SELECT points FROM v_scoring WHERE cat_id = 1 AND scoring_id=1  AND det_id = 2);\
	SET feedback2 = (SELECT det_feed FROM v_scoring WHERE cat_id = 1 AND scoring_id=1  AND det_id = 2);\
	CALL sp_contact_score_user(Uphone,Umail,Sphone,Smail,feedback1,feedback2,contact_user_score,identification_details);\
    /*-----------------    identity_user_score ---------------------- */\
    SET Sdni_o = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 3);\
	SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 3);\
    SET Sdni_r = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 4);\
	SET feedback2 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 4);\
	CALL sp_identity_user_score(user_id,Sdni_o,Sdni_r,feedback1,feedback2,identity_user_score,identification_details);\
	/*----------------    national_user_score ----------------------- */\
	SET Snational = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 5);\
	SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 5);\
	SET Srut = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 6);\
	SET feedback2 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 6);\
	SET Sprovitional = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 7);\
	SET feedback3 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 7);\
    SET Spassport = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 8);\
	SET feedback4 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 8);\
\
    SET country = (SELECT id from countries where valid);\
	CALL sp_nationality_score_user(	country, Ucountry,Udocument, Snational,Srut,Sprovitional, Spassport,\
							feedback1,feedback2,feedback3,feedback4, identification_details,nationality_score_user);\
\
	SET identification_score = contact_user_score + identity_user_score + nationality_score_user;\
	SET score = score + identification_score;\
	/*--------------------------------------------------------------------\
					CATEGORY = 2\
	guarantor_score	= 	guarantor_confirmation_score +\
						guarantor_identification_score\
	---------------------------------------------------------------------*/\
\
	/*----------------    guarantor_confirmation_score ----------------------- */\
	SET Sconfirmed = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 9);\
	SET Sunconfirmed = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 10);\
	SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 10);\
\
	SET Sinsurance = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 11);\
	SET feedback2 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 11);\
\
	CALL sp_endorsement_score_user(Uconfirmed_collateral,Sconfirmed, Sunconfirmed,Uinsurance, Sinsurance, feedback1,\
									feedback2,guarantor_details,guarantor_confirmation_score);\
\
	IF Uconfirmed_collateral = true THEN\
		/*----------------    contact_guarantor_score ----------------------- */\
		SET Sphone = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 12);\
		SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 12);\
    	SET Smail = (SELECT points FROM v_scoring WHERE cat_id = 2 AND scoring_id=1  AND det_id = 13);\
		SET feedback2 = (SELECT det_feed FROM v_scoring WHERE cat_id = 2 AND scoring_id=1  AND det_id = 13);\
\
		SET Umail = (SELECT mail_verified FROM users WHERE id = Ucollateral_id);\
		SET Uphone = (SELECT mail_verified FROM users WHERE id = Ucollateral_id);\
		CALL sp_contact_score_user(Uphone,Umail,Sphone,Smail,feedback1,feedback2, contact_guarantor_score,guarantor_details);\
		/*-----------------    identity_guarantor_score ---------------------- */\
		SET Sdni_o = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 14);\
		SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 14);\
		SET Sdni_r = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 15);\
		SET feedback2 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 15);\
		CALL sp_identity_user_score(Ucollateral_id,Sdni_o,Sdni_r,feedback1,feedback2,identity_guarantor_score,guarantor_details);\
		/*----------------    national_guarantor_score ----------------------- */\
		SET Snational = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 16);\
		SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 16);\
		SET Srut = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 17);\
		SET feedback2 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 17);\
		SET Sprovitional = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 18);\
		SET feedback3 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 18);\
\
		SET Spassport = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 19);\
		SET feedback4 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 19);\
		SET country = (SELECT id from countries where valid);\
\
		SET Ucountry = (SELECT country_id FROM users WHERE id = Ucollateral_id);\
		SET Udocument = (SELECT document_type FROM users WHERE id = Ucollateral_id);\
\
		CALL sp_nationality_score_user(	country, Ucountry,Udocument, Snational,Srut,Sprovitional, Spassport,\
								feedback1,feedback2,feedback3,feedback4, guarantor_details,nationality_guarantor_score);\
		SET guarantor_identification_score = contact_guarantor_score + identity_guarantor_score + nationality_guarantor_score;\
	END IF;\
\
	SET guarantor_score = guarantor_identification_score + guarantor_confirmation_score;\
	SET score = score + guarantor_score;\
	/*--------------------------------------------------------------------\
					CATEGORY = 3\
	socioeconomic_stability_score = job_type_score +\
				job_docs_score\
	---------------------------------------------------------------------*/\
	SET Semploy = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 20);\
	SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 20);\
	SET SafpE = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 21);\
	SET feedback2 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 21);\
	SET SdicomE = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 22);\
	SET feedback3 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 22);\
	SET Sf_set = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 23);\
	SET feedback4 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 23);\
	SET Ss_set = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 24);\
	SET feedback5 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 24);\
	SET St_set = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 25);\
	SET feedback6 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 25);\
	SET Swork = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 26);\
	SET feedback7 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 26);\
\
	SET Sfree = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 27);\
	SET feedback8 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 27);\
	SET SafpF = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 28);\
	SET feedback9 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 28);\
	SET SdicomF = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id =29 );\
	SET feedback10 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id =29 );\
	SET SotherF = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 30);\
	SET feedback11 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 30);\
	SET SsavesF = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 31);\
	SET feedback12 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 31);\
	SET Slast = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 32);\
	SET feedback13 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 32);\
\
	SET Sunemploy = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 33);\
	SET feedback14 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 33);\
	SET SafpU = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 34);\
	SET feedback15 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 34);\
	SET SdicomU = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 35);\
	SET feedback16 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 35);\
	SET SotherU = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 36);\
	SET feedback17 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 36);\
	SET SsavesU = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 37);\
	SET feedback18 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 37);\
	/*----------------    job_type_score ----------------------- */\
	CALL sp_job_user_score(  Ujob, Semploy, Sfree, Sunemploy,feedback1,feedback8, feedback14, socioeconomic_stability_details,\
	 						job_type_score);\
	/*----------------    job_docs_score ----------------------- */\
\
	CALL sp_docs_user_score(user_id, Ujob,SafpE,SafpF, SafpU,SdicomE,SdicomF,SdicomU,\
					SotherF,SotherU,SsavesF, SsavesU,Sf_set,Ss_set,St_set,Swork, Slast,\
					feedback2, feedback3, feedback4, feedback5, feedback6,\
					feedback7, feedback9, feedback10, feedback11, feedback12,\
					feedback13, feedback15, feedback16, feedback17, feedback18,\
					socioeconomic_stability_details, job_docs_score);\
\
	SET socioeconomic_stability_score = job_type_score + job_docs_score;\
	SET score = socioeconomic_stability_score + score;\
	/*--------------------------------------------------------------------\
					CATEGORY = 4\
	preferences_conditions_score = preferences_score +\
				conditions_score\
	---------------------------------------------------------------------*/\
	SET Spro_type = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 38);\
	SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 38);\
	SET Spro_for = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 39);\
	SET feedback2 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 39);\
	SET Sdate = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 40);\
	SET feedback3 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 40);\
	SET Spet = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 41);\
	SET feedback4 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 41);\
	SET Ssmock = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 42);\
	SET feedback5 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 42);\
	SET Swarranty1 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 43);\
	SET feedback6 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 43);\
	SET Swarranty2 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 44);\
	SET feedback7 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 44);\
	SET Swarranty3 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 45);\
	SET feedback8 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 45);\
	SET Sadvancement1 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 46);\
	SET feedback9 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 46);\
	SET Sadvancement2 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 47);\
	SET feedback10 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 47);\
	SET Sadvancement3 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 48);\
	SET feedback11 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 48);\
	SET Stime1 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 49);\
	SET feedback12 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 49);\
	SET Stime2 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 50);\
	SET feedback13 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 50);\
	/*----------------    preferences_score ----------------------- */\
	CALL sp_preferences_score( Spro_type,Spro_for,\
					Sdate,Spet,Ssmock,Upet,Ppet,Usmock,\
					Psmock, Upro_type,	Ppro_type, Udate,\
					Pdate,	user_id, property_id,\
					feedback1, feedback2, feedback3,\
					feedback4,feedback5,conditions_and_preferences_details,\
					preferences_score\
					);\
\
	/*----------------    conditions_score ----------------------- */\
	CALL sp_conditions_score(\
	 		Uwarranty, Uadvancement, Utime,\
     		Swarranty1,	Swarranty2,	Swarranty3,\
	 		Sadvancement1, Sadvancement2,	Sadvancement3,\
	 		Stime1,	Stime2,\
		 	feedback6, feedback7, feedback8,\
			feedback9, feedback10, feedback11,\
			feedback12, feedback13, conditions_and_preferences_details, conditions_score);\
\
	 SET preferences_conditions_score = preferences_score +	conditions_score;\
	 SET score = preferences_conditions_score + score;\
\
	 /*--------------------------------------------------------------------\
	 				CATEGORY = 5\
		membership_score\
	 ---------------------------------------------------------------------*/\
\
	 SET Smembership1 = (SELECT points  FROM v_scoring  WHERE cat_id = 5 AND scoring_id=1  AND det_id = 51);\
	 SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 5 AND scoring_id=1  AND det_id = 51);\
	 SET Smembership2 = (SELECT points  FROM v_scoring  WHERE cat_id = 5 AND scoring_id=1  AND det_id = 52);\
	 SET feedback2 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 5 AND scoring_id=1  AND det_id = 52);\
	 SET Smembership3 = (SELECT points  FROM v_scoring  WHERE cat_id = 5 AND scoring_id=1  AND det_id = 53);\
	 SET feedback3 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 5 AND scoring_id=1  AND det_id = 53);\
\
	 CALL sp_membership_user_score(user_id, Smembership1, Smembership2, Smembership3,feedback1, feedback2,\
	 							feedback3, memberships_details, membership_score);\
	 SET score = membership_score +score;\
	 /*--------------------------------------------------------------------\
	 			   CATEGORY = 6\
	    finantial_score\
	 ---------------------------------------------------------------------*/\
	 SET Sfinantial = (SELECT points  FROM v_scoring  WHERE cat_id = 6 AND scoring_id=1  AND det_id = 54);\
	 SET feedback1 = (SELECT det_feed  FROM v_scoring  WHERE cat_id = 6 AND scoring_id=1  AND det_id = 54);\
	 CALL sp_finantial_user_score(Ujob, Prent, Uamount, Usave, Uother, Ulast, Sfinantial,\
	 						feedback1, finantial_details, finantial_score);\
	 SET score = finantial_score + score;\
	/*-------------------------------------------------------------*/\
\
/*\
contact_user_score,\
		identification_score,\
		nationality_score_user,\
		guarantor_score,\
		guarantor_confirmation_score,\
		guarantor_identification_score,\
		job_type_score,\
		job_docs_score,\
		socioeconomic_stability_score,\
		conditions_score,\
		preferences_score,\
		membership_score,\
		Ujob,Prent, Uamount, Usave, Uother, Ulast, Sfinantial,finantial_score,\
		identification_score,\
		identity_user_score,\
	 	contact_user_score,\
		nationality_score_user,\
		identification_details,\
		identification_feedback,\
		guarantor_score,\
		guarantor_identification_score,\
		guarantor_confirmation_score,\
		guarantor_details,\
		guarantor_feedback,score,\
		preferences_conditions_score, preferences_score,conditions_score,conditions_and_preferences_details,\
		socioeconomic_stability_score, job_type_score, job_docs_score, socioeconomic_stability_details, membership_score;\
		memberships_details, membership_score,\
		finantial_details, finantial_score;\
\
*/\
	select\
		identification_score, identification_details, identification_feedback,\
		guarantor_score, guarantor_details, guarantor_feedback,\
		socioeconomic_stability_score, socioeconomic_stability_details, socioeconomic_stability_feedback,\
		preferences_conditions_score,conditions_and_preferences_details,conditions_and_preferences_feedback,\
		membership_score, memberships_details, memberships_feedback,\
		finantial_score, finantial_details,finantial_feedback,\
		score;\
END$$\
\
--\
-- Functions\
--\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_applied` (`user` INT, `property` INT) RETURNS TINYINT(1) BEGIN\
	DECLARE result int DEFAULT 0;\
	SET result = (select count(postulates.id)\
						from postulates\
						INNER JOIN users_has_properties\
							ON users_has_properties.id = postulates.id\
						WHERE users_has_properties.user_id = user\
                            AND users_has_properties.type = 2\
                            AND postulates.espera = 0\
                            AND users_has_properties.property_id = property);\
	IF (result > 0) then\
		RETURN true;\
	else\
		RETURN false;\
	end if;\
\
\
RETURN false;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_conditions_score` (`Uwarranty` INT, `Uadvancement` INT, `Utime` INT, `Swarranty1` INT, `Swarranty2` INT, `Swarranty3` INT, `Sadvancement1` INT, `Sadvancement2` INT, `Sadvancement3` INT, `Stime1` INT, `Stime2` INT) RETURNS INT(11) BEGIN\
    DECLARE points int DEFAULT 0;\
\
    if (Uwarranty = 1) then\
        SET points = points + Swarranty1;\
    end if;\
    if (Uwarranty = 2 ) then\
        SET points = points + Swarranty2;\
    end if;\
    if (Uwarranty > 2) then\
        SET points = points + Swarranty3;\
    end if;\
\
    if (Uadvancement = 1) then\
        SET points = points + Sadvancement1;\
    end if;\
    if (Uadvancement = 2 ) then\
        SET points = points + Sadvancement2;\
    end if;\
    if (Uadvancement > 2) then\
        SET points = points + Sadvancement3;\
    end if;\
\
    if (Utime < 12) then\
        SET points = points + Stime1;\
    end if;\
    if (Utime >= 2 ) then\
        SET points = points + Stime2;\
    end if;\
    RETURN points;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_contact_user_score` (`has_phone` BOOL, `has_mail` BOOL, `score_phone` INT, `score_mail` INT) RETURNS INT(11) BEGIN\
            DECLARE total int ;\
            SET total = 0;\
\
            IF has_phone THEN\
               SET total = total + score_phone;\
            END IF;\
\
            IF has_mail THEN\
               SET total = total + score_mail;\
            END IF;\
\
            RETURN total;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_demand` (`property` INT) RETURNS INT(11) BEGIN\
\
	DECLARE post int DEFAULT 0;\
	DECLARE Slow int DEFAULT 0;\
\
	DECLARE Smedium int DEFAULT 0;\
	DECLARE done bool DEFAULT false;\
\
	DECLARE Shigh int DEFAULT 0;\
	DECLARE level int DEFAULT 0;\
\
    SET Shigh = (SELECT points  FROM v_scoring  WHERE cat_id = 7 AND scoring_id=2  AND det_id = 54);\
    SET Smedium = (SELECT points  FROM v_scoring  WHERE cat_id = 7 AND scoring_id=2  AND det_id = 55);\
    SET Slow = (SELECT points  FROM v_scoring  WHERE cat_id = 7 AND scoring_id=2  AND det_id = 56);\
\
	SET post = (SELECT count(id)\
		FROM users_has_properties\
        WHERE property_id =property AND\
				type = 2);\
\
    IF post < Slow THEN\
     	RETURN 0;\
   	ELSE\
   		IF post >= Slow and post <= Smedium THEN\
   			RETURN 1;\
   		ELSE\
   			RETURN 2;\
   		END IF;\
\
    END IF;\
\
    RETURN level;\
\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_demand_property` (`property` INT) RETURNS INT(11) BEGIN\
\
	DECLARE post int DEFAULT 0;\
	DECLARE Slow int DEFAULT 0;\
\
	DECLARE done bool DEFAULT false;\
\
	DECLARE Shigh int DEFAULT 0;\
	DECLARE level int DEFAULT 0;\
\
    SET Shigh = 30;\
    SET Slow = 15;\
\
	/** Se comenta la consulta por nuevo conteo de visitas\
\
	SET post = (SELECT count(id)\
		FROM users_has_properties\
        WHERE property_id =property AND\
				type = 2);**/\
\
	SET post = (SELECT views\
		FROM properties\
		WHERE id = property);\
\
    IF post < Slow THEN\
     	RETURN 0;\
   	ELSE\
   		IF post >= Slow and post <= Shigh THEN\
   			RETURN 1;\
   		ELSE\
   			RETURN 2;\
   		END IF;\
\
    END IF;\
\
    RETURN level;\
\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_docs_user_score` (`Uuser_id` INT, `Ujob` INT, `SafpE` INT, `SafpF` INT, `SafpU` INT, `SdicomE` INT, `SdicomF` INT, `SdicomU` INT, `SotherF` INT, `SotherU` INT, `SsavesF` INT, `SsavesU` INT, `Sf_set` INT, `Ss_set` INT, `St_set` INT, `Swork` INT, `Slast` INT) RETURNS INT(11) BEGIN\
    DECLARE points int DEFAULT 0;\
    DECLARE done bool DEFAULT false;\
    DECLARE Dname varchar(60) DEFAULT '';\
    DECLARE Dfactor integer DEFAULT 0;\
    DECLARE Dval_date boolean DEFAULT 0;\
\
    DECLARE docs CURSOR FOR\
            SELECT name, factor, val_date\
            FROM files\
            WHERE user_id = Uuser_id and verified;\
\
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;\
\
    /* recorrido de los documentos*/\
\
    OPEN docs;\
    get_docs: LOOP\
    FETCH docs INTO Dname, Dfactor, Dval_date;\
\
    IF done  THEN\
        LEAVE get_docs;\
    else\
        CASE Ujob\
            WHEN 1 THEN\
                if Dname = 'afp' then\
                    if Dval_date = true then\
                        set points =  points + SafpE;\
                    end if;\
                end if;\
                if Dname = 'dicom' then\
                    set points =  points + ((Dfactor*SdicomE)/999);\
                end if;\
                if Dname = 'first_settlement' then\
                    set points =  points + Sf_set;\
                end if;\
                if Dname = 'second_settlement' then\
                    set points =  points + Ss_set;\
                end if;\
                if Dname = 'third_settlement' then\
                    set points =  points + St_set;\
                end if;\
                if Dname = 'work_constancy' then\
                    set points =  points + Swork;\
                end if;\
            WHEN 2 THEN\
                if Dname = 'afp' then\
                    if Dval_date = true then\
                        set points =  points + SafpF;\
                    end if;\
                end if;\
                if Dname = 'dicom' then\
                    set points =  points + ((Dfactor*SdicomF)/999);\
                end if;\
\
                if Dname = 'other_income' then\
                    set points =  points + SotherF;\
                end if;\
                if Dname = 'last_invoice' then\
                    set points =  points + Slast;\
                end if;\
                if Dname = 'saves' then\
                    set points =  points + SsavesF;\
                end if;\
            WHEN 3 THEN\
                if Dname = 'afp' then\
                    if Dval_date = true then\
                        set points =  points + SafpU;\
                    end if;\
                end if;\
                if Dname = 'dicom' then\
                    set points =  points + ((Dfactor*SdicomU)/999);\
                end if;\
                if Dname = 'other_income' then\
                    set points =  points + SotherU;\
                end if;\
                if Dname = 'saves' then\
                    set points =  points + SsavesU;\
                end if;\
            ELSE set points = 0;\
        END CASE;\
    END IF;\
END LOOP get_docs;\
CLOSE docs;\
\
RETURN points;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_endorsement_score_user` (`confirmed` BOOL, `confirmed_points` INT, `unconfirmed_points` INT, `Uinsurance` BOOL, `Sinsurance` INT) RETURNS INT(11) BEGIN\
    DECLARE points int(11) DEFAULT 0;\
    IF confirmed THEN\
        SET  points = confirmed_points;\
    ELSE\
        SET  points = unconfirmed_points;\
    END IF;\
\
    IF Uinsurance THEN\
        SET  points = points + Sinsurance;\
    END IF;\
    RETURN points;\
\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_favorite` (`user` INT, `property` INT) RETURNS TINYINT(1) BEGIN\
	DECLARE result bool DEFAULT false;\
	SET result = (select count(id)\
						from users_has_properties\
						where 	user_id = user and\
								property_id = property and\
								type = 3);\
	IF (result > 0) then\
		RETURN true;\
	else\
		RETURN false;\
	end if;\
\
\
RETURN false;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_finantial_user_score` (`Uuser_id` INT, `type_empl` INT, `rent` INT, `amount` INT, `save` INT, `other` INT, `last_invo` INT, `points` INT) RETURNS INT(11) BEGIN\
    DECLARE score INT;\
    DECLARE amount_verified int default 0;\
    DECLARE other_income_verified int default 0;\
    DECLARE last_invoice_verified int default 0;\
    DECLARE saves_verified int default 0;\
    DECLARE Dname varchar(60) DEFAULT '';\
    DECLARE Dfactor integer DEFAULT 0;\
    DECLARE Dval_date boolean DEFAULT 0;\
    DECLARE summary float default 0;\
    DECLARE done bool DEFAULT false;\
\
    DECLARE docs CURSOR FOR\
            SELECT name, factor, val_date\
            FROM files\
            WHERE user_id = Uuser_id and verified;\
\
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;\
\
    OPEN docs;\
    get_docs: LOOP\
    FETCH docs INTO Dname, Dfactor, Dval_date;\
\
    IF done  THEN\
        LEAVE get_docs;\
    else\
        if Dname = 'first_settlement' then\
            set amount_verified = amount_verified + Dfactor;\
        end if;\
        if Dname = 'second_settlement' then\
            set amount_verified = amount_verified + Dfactor;\
        end if;\
        if Dname = 'third_settlement' then\
            set amount_verified = amount_verified + Dfactor;\
        end if;\
\
        if Dname = 'other_income' then\
            set other_income_verified = other_income_verified + Dfactor;\
        end if;\
\
        if Dname = 'last_invoice' then\
            set last_invoice_verified = last_invoice_verified + Dfactor;\
        end if;\
        \
        if Dname = 'saves' then\
            set saves_verified = saves_verified + Dfactor;\
        end if;\
    END IF;\
    END LOOP get_docs;\
    CLOSE docs;\
\
    CASE type_empl\
        WHEN 1 THEN\
            SET summary = (amount_verified/3) + saves_verified/12 +  other_income_verified;\
        WHEN 2 THEN\
            SET summary = last_invoice_verified + saves_verified/12 + other_income_verified;\
        WHEN 3 THEN\
            SET summary =  saves_verified/12 + other_income_verified;\
        ELSE RETURN 0;\
    END CASE;\
    SET summary = summary *.35;\
    if summary >= rent then\
        RETURN points;\
    else\
        RETURN points*(summary/rent);\
    end if;\
\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_identity_user_score` (`Uuser_id` INT, `Sdni_o` INT, `Sdni_r` INT) RETURNS INT(11) BEGIN\
    DECLARE points int DEFAULT 0;\
    DECLARE done bool DEFAULT false;\
    DECLARE Dname varchar(60) DEFAULT '';\
\
    DECLARE docs CURSOR FOR\
            SELECT name\
            FROM files\
            WHERE user_id = Uuser_id and verified;\
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;\
    OPEN docs;\
\
    get_docs: LOOP\
        FETCH docs INTO Dname;\
    IF done  THEN\
        LEAVE get_docs;\
    else\
        if Dname = 'id_front' then\
            set points =  points + Sdni_o;\
        end if;\
        if Dname = 'id_back' then\
            set points =  points + Sdni_r;\
        end if;\
    END IF;\
END LOOP get_docs;\
\
CLOSE docs;\
RETURN points;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_job_user_score` (`employment_type` INT, `employe_point` INT, `free_points` INT, `unemploye_point` INT) RETURNS INT(11) BEGIN\
\
    IF(employment_type IS NULL) then\
        RETURN unemploye_point;\
    else\
        CASE employment_type\
            WHEN 1 THEN\
                RETURN employe_point;\
            WHEN 2 THEN\
                    RETURN free_points;\
            WHEN 3 THEN\
                    RETURN unemploye_point;\
            ELSE RETURN 0;\
        END CASE;\
    end if;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_membership_user_score` (`user_id` VARCHAR(20), `basic_points` INT, `select_points` INT, `prime_points` INT) RETURNS INT(11) BEGIN\
    DECLARE member varchar(20) DEFAULT '';\
    SET member = (select  c.name  from\
                users as a,\
                users_has_memberships as b,\
                memberships as c,\
                roles as d\
        where\
                a.id = user_id and\
                a.id = b.user_id and\
                b.membership_id = c.id and\
                d.id =c.role_id and\
                d.name = 'Arrendatario');\
        IF(member IS NULL) then\
            RETURN 0;\
        end if;\
        IF(member = 'Basic') then\
            RETURN basic_points;\
        end if;\
        IF(member = 'Select') then\
            RETURN select_points;\
        end if;\
        IF(member = 'Premium') then\
            RETURN prime_points;\
        end if;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_nationality_score_user` (`country` INT, `origin` INT, `document` VARCHAR(20), `national_u` INT, `rut` INT, `provisional` INT, `pass` INT) RETURNS INT(11) BEGIN\
\
    if origin = country  then\
        RETURN national_u;\
    else\
        IF (document IS NULL) then\
            RETURN 0;\
        else\
            if document = 'RUT_PROVISIONAL' then\
                RETURN provisional;\
            else\
                if document = 'PASAPORTE' then\
                    RETURN pass;\
                else\
                    if document = 'RUT' then\
                        RETURN rut;\
                    else\
                        RETURN 0;\
                    end if;\
\
                end if;\
            end if;\
        end if;\
    end if;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_preferences_score` (`Spro_type` INT, `Spro_for` INT, `Sdate` INT, `Spet` INT, `Ssmock` INT, `Upet` VARCHAR(20), `Ppet` VARCHAR(20), `Usmock` BOOL, `Psmock` BOOL, `Utype` INT, `Ptype` INT, `Udate` DATE, `Pdate` DATE, `user_id` INT, `property_id` INT) RETURNS INT(11) BEGIN\
    DECLARE sco int DEFAULT 0;\
    DECLARE value_id int;\
\
    if Upet = Ppet then\
        set sco = sco + Spet;\
    end if;\
\
    if Usmock = Psmock then\
        set sco = sco + Ssmock;\
    end if;\
\
    if Utype = Ptype then\
        set sco = sco + Spro_type;\
    end if;\
\
    if Udate >= Pdate then\
        set sco = sco + Sdate;\
    end if;\
    set value_id =(select properties_has_properties_for.id\
        from    properties_has_properties_for,\
                users, properties\
        where\
            users.id = user_id and\
            properties.id = property_id and\
            properties.id =properties_has_properties_for.property_id and\
            users.property_for = properties_has_properties_for.property_for_id);\
\
    IF not (value_id IS NULL) then\
            set sco = sco + Spro_for;\
    end if;\
\
    RETURN sco;\
END$$\
\
CREATE DEFINER=`root`@`localhost` FUNCTION `sf_score` (`user_id` INT, `property_id` INT) RETURNS INT(11) BEGIN\
	DECLARE done int DEFAULT false;\
    /* 			contact function var 				*/\
    DECLARE score int(11) DEFAULT 0;\
    DECLARE Smail int(11) DEFAULT 0;\
    DECLARE Sphone int(11) DEFAULT 0;\
	DECLARE Sinsurance int(11) DEFAULT 0;\
	DECLARE Uinsurance bool DEFAULT 0;\
    DECLARE Umail bool;\
    DECLARE Uphone bool;\
    DECLARE Ucountry int(11) DEFAULT 0;\
    DECLARE Udocument varchar(20);\
    /* 			contact function var 					*/\
    DECLARE Sdni_o int(11) DEFAULT 0;\
    DECLARE Sdni_r int(11) DEFAULT 0;\
\
	/*		 	nationality_score_user vars 			*/\
\
	DECLARE Snational int(11) DEFAULT 0;\
	DECLARE Srut int(11) DEFAULT 0;\
    DECLARE Sprovitional int(11) DEFAULT 0;\
    DECLARE Spassport int(11) DEFAULT 0;\
	DECLARE country int(11) DEFAULT 0;\
	DECLARE nationality_score_user int(11) DEFAULT 0;\
	/* 			guarantor_score Vars 			*/\
	DECLARE Ucollateral_id int(11) DEFAULT 0;\
	DECLARE Sconfirmed int(11) DEFAULT 0;\
	DECLARE Sunconfirmed int(11) DEFAULT 0;\
	DECLARE Uconfirmed_collateral bool;\
	DECLARE guarantor_score int(11) DEFAULT 0;\
	DECLARE guarantor_confirmation_score int(11) DEFAULT 0;\
	DECLARE guarantor_identification_score int(11) DEFAULT 0;\
	DECLARE contact_guarantor_score int(11) DEFAULT 0;\
	DECLARE identity_guarantor_score int(11) DEFAULT 0;\
	DECLARE nationality_guarantor_score int(11) DEFAULT 0;\
    /* 			Categories Vars 			*/\
    DECLARE contact_user_score int(11) DEFAULT 0;\
    DECLARE identity_user_score int(11) DEFAULT 0;\
	DECLARE identification_user_score int(11) DEFAULT 0;\
	/* 			 job_score vars				*/\
	DECLARE Ujob int(11) DEFAULT 0;\
	DECLARE Semploy int(11) DEFAULT 0;\
	DECLARE SafpE int(11) DEFAULT 0;\
	DECLARE SdicomE int(11) DEFAULT 0;\
	DECLARE Sf_set int(11) DEFAULT 0;\
	DECLARE Ss_set int(11) DEFAULT 0;\
	DECLARE St_set int(11) DEFAULT 0;\
	DECLARE Swork int(11) DEFAULT 0;\
	DECLARE Sfree int(11) DEFAULT 0;\
	DECLARE SafpF int(11) DEFAULT 0;\
	DECLARE SdicomF int(11) DEFAULT 0;\
	DECLARE SotherF int(11) DEFAULT 0;\
	DECLARE SsavesF int(11) DEFAULT 0;\
	DECLARE Slast int(11) DEFAULT 0;\
	DECLARE Sunemploy int(11) DEFAULT 0;\
	DECLARE SafpU int(11) DEFAULT 0;\
	DECLARE SdicomU int(11) DEFAULT 0;\
	DECLARE SotherU int(11) DEFAULT 0;\
	DECLARE SsavesU int(11) DEFAULT 0;\
	DECLARE job_type_score int(11) DEFAULT 0;\
	DECLARE job_docs_score int(11) DEFAULT 0;\
	DECLARE job_score int(11) DEFAULT 0;\
	/* preferences and conditions Vars*/\
	DECLARE preferences_score int(11) DEFAULT 0;\
	DECLARE conditions_score int(11) DEFAULT 0;\
	DECLARE preferences_conditions_score int(11) DEFAULT 0;\
\
	DECLARE Prent int(11) DEFAULT 0;\
	DECLARE Ppet varchar(30) DEFAULT 0;\
	DECLARE Psmock boolean DEFAULT 0;\
	DECLARE Ppro_type int(11) DEFAULT 0;\
	DECLARE Pdate date ;\
	DECLARE Pcollateral boolean DEFAULT 0;\
\
	DECLARE Upet varchar(30) DEFAULT 0;\
	DECLARE Usmock boolean DEFAULT 0;\
	DECLARE Upro_type int(11) DEFAULT 0;\
	DECLARE Udate date ;\
	DECLARE Uwarranty int DEFAULT 0;\
	DECLARE Uadvancement int DEFAULT 0;\
	DECLARE Utime int DEFAULT 0;\
\
	DECLARE Spro_type int DEFAULT 0;\
	DECLARE Spro_for int DEFAULT 0;\
	DECLARE Sdate int DEFAULT 0;\
	DECLARE Spet int DEFAULT 0;\
	DECLARE Ssmock int DEFAULT 0;\
	DECLARE Swarranty1 int DEFAULT 0;\
	DECLARE Swarranty2 int DEFAULT 0;\
	DECLARE Swarranty3 int DEFAULT 0;\
	DECLARE Sadvancement1 int DEFAULT 0;\
	DECLARE Sadvancement2 int DEFAULT 0;\
	DECLARE Sadvancement3 int DEFAULT 0;\
	DECLARE Stime1 int DEFAULT 0;\
	DECLARE Stime2 int DEFAULT 0;\
	/*  	memberships Vars  		 */\
	DECLARE Smembership1 int DEFAULT 0;\
	DECLARE Smembership2 int DEFAULT 0;\
	DECLARE Smembership3 int DEFAULT 0;\
	DECLARE membership_score int DEFAULT 0;\
	/*  	finantial Vars  		 */\
	DECLARE finantial_score int DEFAULT 0;\
	DECLARE Sfinantial int DEFAULT 0;\
	DECLARE Uamount int DEFAULT 0;\
	DECLARE Usave int DEFAULT 0;\
	DECLARE Uother int DEFAULT 0;\
	DECLARE Ulast int DEFAULT 0;\
\
\
	/*			Cursor	  Arrendadores					*/\
    DECLARE lessor CURSOR FOR\
        SELECT  mail_verified,  phone_verified,\
                country_id, document_type,\
				collateral_id,  confirmed_collateral,\
				employment_type, move_date,\
				warranty_months_quantity,months_advance_quantity,\
				tenanting_months_quantity,property_type,\
				amount, save_amount,\
				other_income_amount, last_invoice_amount,\
				tenanting_insurance\
\
        FROM users\
        WHERE id = user_id;\
	/*	  			Cursor propiedades					*/\
	DECLARE property CURSOR FOR\
        SELECT 	rent, pet_preference,\
            	smoking_allowed, property_type_id,\
                available_date, collateral_require\
	    FROM properties\
        WHERE property_id=id;\
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;\
	/* SETEO de Variables de Arrendador */\
    OPEN lessor;\
    get_lessor: LOOP\
        FETCH lessor INTO   Umail,Uphone,\
                            Ucountry, Udocument,\
							Ucollateral_id, Uconfirmed_collateral,\
							Ujob,Udate,\
							Uwarranty,Uadvancement,\
							Utime,Upro_type,\
							Uamount,Usave,\
							Uother, Ulast,\
							Uinsurance;\
        IF done  THEN\
            LEAVE get_lessor;\
        END IF;\
    END LOOP get_lessor;\
    CLOSE lessor;\
	/* SETEO de Variables de Propiedades */\
	OPEN property;\
	get_property: LOOP\
	FETCH property INTO Prent, Ppet,\
						Psmock, Ppro_type,\
						Pdate, Pcollateral;\
\
		IF done  THEN\
			LEAVE get_property;\
		END IF;\
\
	END LOOP get_property;\
	CLOSE property;\
	/*---------------------------------------------------------------\
						CATEGORY = 1\
     identification_user_score  = 	contact_user_score +\
	 								nationality_score_user\
	---------------------------------------------------------------	*/\
\
	/*---------------------- contact_user_score---------------------*/\
    SET Sphone = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 1);\
    SET Smail = (SELECT points FROM v_scoring WHERE cat_id = 1 AND scoring_id=1  AND det_id = 2);\
\
    SET contact_user_score = sf_contact_user_score(Uphone,Umail,Sphone,Smail);\
    /*-----------------    identity_user_score ---------------------- */\
    SET Sdni_o = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 3);\
    SET Sdni_r = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 4);\
    SET identity_user_score = sf_identity_user_score(user_id,Sdni_o,Sdni_r);\
	/*----------------    national_user_score ----------------------- */\
	SET Snational = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 5);\
	SET Srut = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 6);\
	SET Sprovitional = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 7);\
    SET Spassport = (SELECT points  FROM v_scoring  WHERE cat_id = 1 AND scoring_id=1  AND det_id = 8);\
\
    SET country = (SELECT id from countries where valid);\
    SET nationality_score_user = sf_nationality_score_user(	country, Ucountry,Udocument, Snational,Srut,Sprovitional, Spassport);\
	SET identification_user_score = contact_user_score + identity_user_score + nationality_score_user;\
	SET score = score + identification_user_score;\
	/*--------------------------------------------------------------------\
					CATEGORY = 2\
	guarantor_score	= 	guarantor_confirmation_score +\
						guarantor_identification_score\
	---------------------------------------------------------------------*/\
\
	/*----------------    guarantor_confirmation_score ----------------------- */\
	SET Sconfirmed = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 9);\
	SET Sunconfirmed = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 10);\
	SET Sinsurance = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 11);\
	SET guarantor_confirmation_score = sf_endorsement_score_user(Uconfirmed_collateral, Sconfirmed, Sunconfirmed, Uinsurance, Sinsurance);\
\
	IF Uconfirmed_collateral = true THEN\
		/*----------------    contact_guarantor_score ----------------------- */\
		SET Sphone = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 12);\
    	SET Smail = (SELECT points FROM v_scoring WHERE cat_id = 2 AND scoring_id=1  AND det_id = 13);\
\
		SET Umail = (SELECT mail_verified FROM users WHERE id = Ucollateral_id);\
		SET Uphone = (SELECT mail_verified FROM users WHERE id = Ucollateral_id);\
		SET contact_guarantor_score = sf_contact_user_score(Uphone,Umail,Sphone,Smail);\
		/*-----------------    identity_guarantor_score ---------------------- */\
		SET Sdni_o = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 14);\
		SET Sdni_r = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 15);\
		SET identity_guarantor_score = sf_identity_user_score(Ucollateral_id,Sdni_o,Sdni_r);\
		/*----------------    national_guarantor_score ----------------------- */\
		SET Snational = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 16);\
		SET Srut = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 17);\
		SET Sprovitional = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 18);\
\
		SET Spassport = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 19);\
		SET country = (SELECT id from countries where valid);\
\
		SET Ucountry = (SELECT country_id FROM users WHERE id = Ucollateral_id);\
		SET Udocument = (SELECT document_type FROM users WHERE id = Ucollateral_id);\
		SET nationality_guarantor_score = sf_nationality_score_user(country, Ucountry,Udocument, Snational,Srut,Sprovitional, Spassport);\
		SET guarantor_identification_score = contact_guarantor_score + identity_guarantor_score + nationality_guarantor_score;\
	END IF;\
\
	IF Pcollateral = true THEN\
		SET guarantor_score = guarantor_identification_score + guarantor_confirmation_score;\
	ELSE\
\
		SET Sphone = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 12);\
    	SET Smail = (SELECT points FROM v_scoring WHERE cat_id = 2 AND scoring_id=1  AND det_id = 13);\
		SET Sdni_o = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 14);\
		SET Sdni_r = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 15);\
		SET Snational = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 16);\
		SET Srut = (SELECT points  FROM v_scoring  WHERE cat_id = 2 AND scoring_id=1  AND det_id = 17);\
\
		SET guarantor_score = Sphone + Smail + Sdni_o + Sdni_r + Snational + Srut;\
\
	END IF;\
\
	SET score = score + guarantor_score;\
	/*--------------------------------------------------------------------\
					CATEGORY = 3\
	job_score = job_type_score +\
				job_docs_score\
	---------------------------------------------------------------------*/\
	SET Semploy = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 20);\
	SET SafpE = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 21);\
	SET SdicomE = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 22);\
	SET Sf_set = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 23);\
	SET Ss_set = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 24);\
	SET St_set = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 25);\
	SET Swork = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 26);\
\
	SET Sfree = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 27);\
	SET SafpF = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 28);\
	SET SdicomF = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id =29 );\
	SET SotherF = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 30);\
	SET SsavesF = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 31);\
	SET Slast = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 32);\
\
	SET Sunemploy = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 33);\
	SET SafpU = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 34);\
	SET SdicomU = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 35);\
	SET SotherU = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 36);\
	SET SsavesU = (SELECT points  FROM v_scoring  WHERE cat_id = 3 AND scoring_id=1  AND det_id = 37);\
	/*----------------    job_type_score ----------------------- */\
	SET job_type_score = sf_job_user_score(  Ujob, Semploy, Sfree, Sunemploy );\
	/*----------------    job_docs_score ----------------------- */\
	SET job_docs_score = sf_docs_user_score(user_id, Ujob,SafpE,SafpF, SafpU,SdicomE,SdicomF,SdicomU,\
					SotherF,SotherU,SsavesF, SsavesU,Sf_set,Ss_set,St_set,Swork, Slast);\
\
	SET job_score = job_type_score + job_docs_score;\
	SET score = job_score + score;\
	/*--------------------------------------------------------------------\
					CATEGORY = 4\
	preferences_conditions_score = preferences_score +\
				conditions_score\
	---------------------------------------------------------------------*/\
	SET Spro_type = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 38);\
	SET Spro_for = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 39);\
	SET Sdate = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 40);\
	SET Spet = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 41);\
	SET Ssmock = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 42);\
	SET Swarranty1 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 43);\
	SET Swarranty2 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 44);\
	SET Swarranty3 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 45);\
	SET Sadvancement1 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 46);\
	SET Sadvancement2 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 47);\
	SET Sadvancement3 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 48);\
	SET Stime1 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 49);\
	SET Stime2 = (SELECT points  FROM v_scoring  WHERE cat_id = 4 AND scoring_id=1  AND det_id = 50);\
\
	/*----------------    preferences_score ----------------------- */\
	SET preferences_score = sf_preferences_score( Spro_type,Spro_for,\
								Sdate,Spet,Ssmock,Upet,Ppet,Usmock,\
								Psmock, Upro_type,	Ppro_type, Udate,\
								 Pdate,	user_id, property_id);\
	/*----------------    conditions_score ----------------------- */\
	SET conditions_score = sf_conditions_score(\
	 Uwarranty, \
     Uadvancement,\
     Utime,\
     Swarranty1,\
	 Swarranty2,\
	 Swarranty3,\
	 Sadvancement1,\
	 Sadvancement2,\
	 Sadvancement3,\
	 Stime1,\
	 Stime2 );\
	 SET preferences_conditions_score = preferences_score +	conditions_score;\
	 SET score = preferences_conditions_score + score;\
\
	 /*--------------------------------------------------------------------\
	 				CATEGORY = 5\
		membership_score\
	 ---------------------------------------------------------------------*/\
\
	 SET Smembership1 = (SELECT points  FROM v_scoring  WHERE cat_id = 5 AND scoring_id=1  AND det_id = 51);\
	 SET Smembership2 = (SELECT points  FROM v_scoring  WHERE cat_id = 5 AND scoring_id=1  AND det_id = 52);\
	 SET Smembership3 = (SELECT points  FROM v_scoring  WHERE cat_id = 5 AND scoring_id=1  AND det_id = 53);\
\
	 SET membership_score = sf_membership_user_score(user_id, Smembership1, Smembership2, Smembership3);\
\
	 SET score = membership_score +score;\
	 /*--------------------------------------------------------------------\
	 			   CATEGORY = 6\
	    finantial_score\
	 ---------------------------------------------------------------------*/\
	 SET Sfinantial = (SELECT points  FROM v_scoring  WHERE cat_id = 6 AND scoring_id=1  AND det_id = 54);\
	 SET finantial_score = sf_finantial_user_score(user_id, Ujob, Prent, Uamount, Usave, Uother, Ulast, Sfinantial);\
	 SET score = finantial_score+ score;\
	/*-------------------------------------------------------------*/\
\
RETURN score;\
END$$\
\
DELIMITER ;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `amenities`\
--\
\
CREATE TABLE `amenities` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `image` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `type` tinyint(1) NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `amenities`\
--\
\
INSERT INTO `amenities` (`id`, `name`, `image`, `type`) VALUES\
(1, 'Llave con clave de seguridad', NULL, 0),\
(2, 'Caja de seguridad', NULL, 0),\
(3, 'Cubiertos', NULL, 2),\
(4, 'Frazadas y Cobijas', NULL, 2),\
(5, 'Kit de limpieza', NULL, 2),\
(6, 'Kit de limpieza personal', NULL, 2),\
(7, 'Kit de primeros auxilios', NULL, 2),\
(8, 'Platos', NULL, 2),\
(9, 'Toallas', NULL, 2),\
(10, 'Utencilios de cocina', NULL, 2),\
(11, 'WIFI', NULL, 2),\
(12, 'Sala de entretenimiento', NULL, 2),\
(13, 'Est\'e1 prohibido el ruido en exceso', NULL, 3),\
(14, 'Est\'e1 prohibido hacer fiestas o eventos', NULL, 3),\
(15, 'No es apto para beb\'e9s (menores de 2 a\'f1os)', NULL, 3),\
(16, 'Est\'e1 prohibido cocinar', NULL, 3),\
(17, 'Est\'e1 prohibido usar los muebles', NULL, 3),\
(18, 'Est\'e1 prohibido usar los equipos electr\'f3nicos de la propiedad', NULL, 3),\
(19, 'Est\'e1 prohibido cocinar', NULL, 3),\
(20, 'Es necesario utilizar escaleras', NULL, 4),\
(21, 'Puede haber ruido', NULL, 4),\
(22, 'Hay zonas comunes que se comparten con otros hu\'e9spedes', NULL, 4),\
(23, 'Limitaciones de servicios', NULL, 4),\
(24, 'Dispositivos de vigilancia o de grabaci\'f3n en la vivienda', NULL, 4),\
(25, 'Armas en la vivienda', NULL, 4),\
(26, 'Hay mascotas en la propiedad', NULL, 4),\
(27, 'Animales peligrosos en la vivienda', NULL, 4),\
(28, 'Conexi\'f3n a linea el\'e9ctrica', NULL, 5),\
(29, 'Conexi\'f3n a aguas blancas', NULL, 5),\
(30, 'Conexi\'f3n a aguas negras', NULL, 5),\
(31, 'Permiso de construcci\'f3n', NULL, 5),\
(32, 'Piso Madera Flotante', NULL, 0),\
(33, 'Piso Alfombras', NULL, 0),\
(34, 'Piso Ceramica', NULL, 0),\
(35, 'Lamparas', NULL, 0),\
(36, 'Puerta con Candado seguridad', NULL, 0),\
(37, 'Alarma Interna', NULL, 0),\
(38, 'Alarma Integrada', NULL, 0),\
(39, 'Calefacci\'f3n Central', NULL, 0),\
(40, 'Calefacci\'f3n a Le\'f1a', NULL, 0),\
(41, 'Calefacci\'f3n Integrada en cada habitaci\'f3n', NULL, 0),\
(42, 'Agua Caliente', NULL, 0),\
(43, 'Cocina Americana', NULL, 0),\
(44, 'Zona Lavanderia', NULL, 0),\
(45, 'Terraza', NULL, 0),\
(46, 'Jardin', NULL, 0),\
(47, 'Terraza con Malla Protecci\'f3n', NULL, 0),\
(48, 'Piscina Temperada', NULL, 0),\
(49, 'Ventilador Techo', NULL, 0),\
(50, 'Losa Radiante', NULL, 0),\
(51, 'Ventanas de Cristal', NULL, 0),\
(52, 'Walk in Close', NULL, 0),\
(53, 'Estacionamiento Visitas', NULL, 0),\
(54, 'Antisismico', NULL, 0),\
(55, 'Cocina a Gas', NULL, 0),\
(56, 'Cocina Electrica', NULL, 0),\
(57, 'Habitaci\'f3n Servicio', NULL, 0),\
(58, 'Piscina No Temperada', NULL, 0),\
(59, 'Habitaci\'f3n Servicio', NULL, 0),\
(60, 'Ascensor Privado', NULL, 0),\
(61, 'Logia', NULL, 0),\
(62, 'Escaleras', NULL, 0),\
(63, 'Quincho', NULL, 0),\
(64, 'Lavadero / Lavador', NULL, 0),\
(65, 'Chimenea', NULL, 0),\
(66, 'Gym', NULL, 1),\
(67, 'Conserjeria', NULL, 1),\
(68, 'Seguridad', NULL, 1),\
(69, 'Jardines', NULL, 1),\
(70, 'Centro de Eventos', NULL, 1),\
(71, 'Centro de Entretenimiento / Cine', NULL, 1),\
(72, 'Centro de Estudio', NULL, 1),\
(73, 'SPA', NULL, 1),\
(74, 'Acceso para Discapacitados', NULL, 1),\
(75, 'Piscina No temperada', NULL, 1),\
(76, 'Quinchos & Zona de Barbacoa', NULL, 1),\
(77, 'Parque Infantil', NULL, 1),\
(78, 'Estacionamiento Visita', NULL, 1),\
(79, 'Ascensores', NULL, 1),\
(80, 'Puntos de Seguridad & Contra Incendio', NULL, 1),\
(81, 'Protecci\'f3n Antisismo', NULL, 1),\
(82, 'Zona de Paqueteria', NULL, 1),\
(83, 'Agua Caliente', NULL, 1),\
(84, 'Ba\'f1os Comunes', NULL, 1),\
(85, 'Piscina Temperada', NULL, 1),\
(86, 'Loza Radiante', NULL, 1),\
(87, 'Reserva de Energia ante Cortes Electricos', NULL, 1),\
(88, 'Escaleras de emergencia', NULL, 1),\
(89, 'Circuito Integrado TV', NULL, 1),\
(90, 'Internet Comunitario', NULL, 1);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `banks`\
--\
\
CREATE TABLE `banks` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `banks`\
--\
\
INSERT INTO `banks` (`id`, `name`) VALUES\
(1, 'Banco de Chile'),\
(2, 'Banco Internacional'),\
(3, 'Scotiabank Chile'),\
(4, 'Banco Cr\'e9dito e Inversiones'),\
(5, 'Banco Bice'),\
(6, 'HSBC Bank '),\
(7, 'Banco Santander'),\
(8, 'Banco Santander Banefe'),\
(9, 'Banco del Desarrollo'),\
(10, 'Corpbanca'),\
(11, 'Banco Security'),\
(12, 'Banco Falabella'),\
(13, 'Banco Ripley'),\
(14, 'Banco Consorcio'),\
(15, 'Banco Bilbao Vizcaya Argentaria'),\
(16, 'Banco BBVA'),\
(17, 'Banco Ita\'fa'),\
(18, 'Banco Estado'),\
(19, 'Banco Falabella'),\
(20, 'Rabobank'),\
(21, 'Banco Paris'),\
(22, 'Banco de Chile / Edwards-Citi'),\
(23, 'Coopeuch'),\
(24, 'Banco BTG Pactual Chile');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `cat_scoring`\
--\
\
CREATE TABLE `cat_scoring` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `scoring_id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',\
  `description` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',\
  `feed_back` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `cat_scoring`\
--\
\
INSERT INTO `cat_scoring` (`id`, `scoring_id`, `name`, `description`, `feed_back`) VALUES\
(1, 1, 'Identidad Digital', 'Scoring Validaci\'f3n de Identidad Digital', 'Retroalimentaci\'f3n para Identidad Digital'),\
(2, 1, 'Codeudor ', 'Scoring Validaci\'f3n de Codeudor ', 'Retroalimentaci\'f3n para Validaci\'f3n de Codeudor '),\
(3, 1, 'Estabilidad Socio-Econ\'f3mica', 'Scoring de Estabilidad Socio-Econ\'f3mica', 'Retroalimentaci\'f3n para Estabilidad Socio-Econ\'f3mica '),\
(4, 1, 'Preferencias y Condiciones para arrendar', 'Scoring de Preferencias y Condiciones para arrendar', 'Retroalimentaci\'f3n para Preferencias y Condiciones para arrendar'),\
(5, 1, 'Membres\'edas', 'Scoring de Membres\'edas', 'Retroalimentaci\'f3n para Membres\'edas'),\
(6, 1, 'Estabilidad Financiera', 'Scoring de Estabilidad Financiera', 'Retroalimentaci\'f3n para Estabilidad Financiera'),\
(7, 2, 'Demanda', 'Scoring Validaci\'f3n de Demanda', 'Retroalimentaci\'f3n para Demanda');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `cities`\
--\
\
CREATE TABLE `cities` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `region_id` int(10) UNSIGNED NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `cities`\
--\
\
INSERT INTO `cities` (`id`, `name`, `region_id`) VALUES\
(1, 'Arica', 1),\
(2, 'Parinacota', 1),\
(3, 'Iquique', 2),\
(4, 'El Tamarugal', 2),\
(5, 'Antofagasta', 3),\
(6, 'El Loa', 3),\
(7, 'Tocopilla', 3),\
(8, 'Cha\'f1aral', 4),\
(9, 'Copiap\'f3', 4),\
(10, 'Huasco', 4),\
(11, 'Choapa', 5),\
(12, 'Elqui', 5),\
(13, 'Limar\'ed', 5),\
(14, 'Isla de Pascua', 6),\
(15, 'Los Andes', 6),\
(16, 'Petorca', 6),\
(17, 'Quillota', 6),\
(18, 'San Antonio', 6),\
(19, 'San Felipe de Aconcagua', 6),\
(20, 'Valparaiso', 6),\
(21, 'Chacabuco', 7),\
(22, 'Cordillera', 7),\
(23, 'Maipo', 7),\
(24, 'Melipilla', 7),\
(25, 'Santiago', 7),\
(26, 'Talagante', 7),\
(27, 'Cachapoal', 8),\
(28, 'Cardenal Caro', 8),\
(29, 'Colchagua', 8),\
(30, 'Cauquenes', 9),\
(31, 'Curic\'f3', 9),\
(32, 'Linares', 9),\
(33, 'Talca', 9),\
(34, 'Arauco', 10),\
(35, 'Bio B\'edo', 10),\
(36, 'Concepci\'f3n', 10),\
(37, '\'d1uble', 10),\
(38, 'Caut\'edn', 11),\
(39, 'Malleco', 11),\
(40, 'Valdivia', 12),\
(41, 'Ranco', 12),\
(42, 'Chilo\'e9', 13),\
(43, 'Llanquihue', 13),\
(44, 'Osorno', 13),\
(45, 'Palena', 13),\
(46, 'Ais\'e9n', 14),\
(47, 'Capit\'e1n Prat', 14),\
(48, 'Coihaique', 14),\
(49, 'General Carrera', 14),\
(50, 'Ant\'e1rtica Chilena', 15),\
(51, 'Magallanes', 15),\
(52, 'Tierra del Fuego', 15),\
(53, '\'daltima Esperanza', 15),\
(54, 'Alto Orinoco', 36),\
(55, 'Atabapo', 36),\
(56, 'Atures', 36),\
(57, 'Autana', 36),\
(58, 'Manapiare', 36),\
(59, 'Maroa', 36),\
(60, 'R\'edo Negro', 36),\
(61, 'Anaco', 35),\
(62, 'Aragua', 35),\
(63, 'Bol\'edvar', 35),\
(64, 'Bruzual', 35),\
(65, 'Cajigal', 35),\
(66, 'Carvajal', 35),\
(67, 'Diego Bautista Urbaneja', 35),\
(68, 'Freites', 35),\
(69, 'Guanipa', 35),\
(70, 'Guanta', 35),\
(71, 'Independencia', 35),\
(72, 'Libertad', 35),\
(73, 'McGregor', 35),\
(74, 'Miranda', 35),\
(75, 'Monagas', 35),\
(76, 'Pe\'f1alver', 35),\
(77, 'P\'edritu', 35),\
(78, 'San Juan de Capistrano', 35),\
(79, 'Santa Ana', 35),\
(80, 'Sim\'f3n Rodr\'edguez', 35),\
(81, 'Sotillo', 35),\
(82, 'Achaguas', 34),\
(83, 'Biruaca', 34),\
(84, 'Mu\'f1oz', 34),\
(85, 'P\'e1ez', 34),\
(86, 'Pedro Camejo', 34),\
(87, 'R\'f3mulo Gallegos', 34),\
(88, 'San Fernando', 34),\
(89, 'Bol\'edvar', 33),\
(90, 'Camatagua', 33),\
(91, 'Francisco Linares Alc\'e1ntara', 33),\
(92, 'Girardot', 33),\
(93, 'Jos\'e9 \'c1ngel Lamas', 33),\
(94, 'Jos\'e9 F\'e9lix Ribas', 33),\
(95, 'Jos\'e9 Rafael Revenga', 33),\
(96, 'Libertador', 33),\
(97, 'Mario Brice\'f1o Iragorry', 33),\
(98, 'Ocumare de la Costa de Oro', 33),\
(99, 'San Casimiro', 33),\
(100, 'San Sebasti\'e1n', 33),\
(101, 'Santiago Mari\'f1o', 33),\
(102, 'Santos Michelena', 33),\
(103, 'Sucre', 33),\
(104, 'Tovar', 33),\
(105, 'Urdaneta', 33),\
(106, 'Zamora', 33),\
(107, 'Alberto Arvelo Torrealba', 32),\
(108, 'Andr\'e9s Eloy Blanco', 32),\
(109, 'Antonio Jos\'e9 de Sucre', 32),\
(110, 'Arismendi', 32),\
(111, 'Barinas', 32),\
(112, 'Bol\'edvar', 32),\
(113, 'Cruz Paredes', 32),\
(114, 'Ezequiel Zamora', 32),\
(115, 'Obispos', 32),\
(116, 'Pedraza', 32),\
(117, 'Rojas', 32),\
(118, 'Sosa', 32),\
(119, 'Angostura', 31),\
(120, 'Caron\'ed', 31),\
(121, 'Cede\'f1o', 31),\
(122, 'El Callao', 31),\
(123, 'Gran Sabana', 31),\
(124, 'Heres', 31),\
(125, 'P\'edar', 31),\
(126, 'Roscio', 31),\
(127, 'Sifontes', 31),\
(128, 'Sucre', 31),\
(129, 'Padre Pedro Chien', 31),\
(130, 'Bejuma', 30),\
(131, 'Carlos Arvelo', 30),\
(132, 'Diego Ibarra', 30),\
(133, 'Guacara', 30),\
(134, 'Mora', 30),\
(135, 'Libertador', 30),\
(136, 'Los Guayos', 30),\
(137, 'Miranda', 30),\
(138, 'Montalb\'e1n', 30),\
(139, 'Naguanagua', 30),\
(140, 'Puerto Cabello', 30),\
(141, 'San Diego', 30),\
(142, 'San Joaqu\'edn', 30),\
(143, 'Valencia', 30),\
(144, 'Anzo\'e1tegui', 29),\
(145, 'Tinaquillo', 29),\
(146, 'Girardot', 29),\
(147, 'Lima Blanco', 29),\
(148, 'Pao de San Juan Bautista', 29),\
(149, 'Ricaurte', 29),\
(150, 'R\'f3mulo Gallegos', 29),\
(151, 'San Carlos', 29),\
(152, 'Tinaco', 29),\
(153, 'Antonio D\'edaz', 28),\
(154, 'Casacoima', 28),\
(155, 'Pedernales', 28),\
(156, 'Tucupita', 28),\
(157, 'Acosta', 27),\
(158, 'Bol\'edvar', 27),\
(159, 'Buchivacoa', 27),\
(160, 'Carirubana', 27),\
(161, 'Colina', 27),\
(162, 'Dabajuro', 27),\
(163, 'Democracia', 27),\
(164, 'Falc\'f3n', 27),\
(165, 'Federaci\'f3n', 27),\
(166, 'Jacura', 27),\
(167, 'Los Taques', 27),\
(168, 'Manaure', 27),\
(169, 'Mauroa', 27),\
(170, 'Miranda', 27),\
(171, 'Monse\'f1or Iturriza', 27),\
(172, 'Palmasola', 27),\
(173, 'Petit', 27),\
(174, 'P\'edritu', 27),\
(175, 'San Francisco', 27),\
(176, 'Sucre', 27),\
(177, 'Silva', 27),\
(178, 'Toc\'f3pero', 27),\
(179, 'Uni\'f3n', 27),\
(180, 'Urumaco', 27),\
(181, 'Zamora', 27),\
(182, 'Camagu\'e1n', 26),\
(183, 'Chaguaramas', 26),\
(184, 'El Socorro', 26),\
(185, 'Infante', 26),\
(186, 'Las Mercedes', 26),\
(187, 'Mellado', 26),\
(188, 'Miranda', 26),\
(189, 'Monagas', 26),\
(190, 'Ortiz', 26),\
(191, 'Ribas', 26),\
(192, 'Roscio', 26),\
(193, 'San Ger\'f3nimo de Guayabal', 26),\
(194, 'San Jos\'e9 de Guaribe', 26),\
(195, 'Santa Mar\'eda de Ipire', 26),\
(196, 'Zaraza', 26),\
(197, 'Andr\'e9s Eloy Blanco', 25),\
(198, 'Crespo', 25),\
(199, 'Iribarren', 25),\
(200, 'Jim\'e9nez', 25),\
(201, 'Mor\'e1n', 25),\
(202, 'Palavecino', 25),\
(203, 'Sim\'f3n Planas', 25),\
(204, 'Torres', 25),\
(205, 'Urdaneta', 25),\
(206, 'Alberto Adriani', 24),\
(207, 'Andr\'e9s Bello', 24),\
(208, 'Antonio Pinto Salinas', 24),\
(209, 'Aricagua', 24),\
(210, 'Arzobispo Chac\'f3n', 24),\
(211, 'Campo El\'edas', 24),\
(212, 'Caracciolo Parra Olmedo', 24),\
(213, 'Cardenal Quintero', 24),\
(214, 'Guaraque', 24),\
(215, 'Julio C\'e9sar Salas', 24),\
(216, 'Justo Brice\'f1o', 24),\
(217, 'Libertador', 24),\
(218, 'Miranda', 24),\
(219, 'Obispo Ramos de Lora', 24),\
(220, 'Padre Noguera', 24),\
(221, 'Pueblo Llano', 24),\
(222, 'Rangel', 24),\
(223, 'Rivas D\'e1vila', 24),\
(224, 'Santos Marquina', 24),\
(225, 'Sucre', 24),\
(226, 'Tovar', 24),\
(227, 'Tulio Febres Cordero', 24),\
(228, 'Zea', 24),\
(229, 'Acevedo', 23),\
(230, 'Andr\'e9s Bello', 23),\
(231, 'Baruta', 23),\
(232, 'Bri\'f3n', 23),\
(233, 'Buroz', 23),\
(234, 'Carrizal', 23),\
(235, 'Chacao', 23),\
(236, 'Crist\'f3bal Rojas', 23),\
(237, 'El Hatillo', 23),\
(238, 'Guaicaipuro', 23),\
(239, 'Independencia', 23),\
(240, 'Lander', 23),\
(241, 'Los Salias', 23),\
(242, 'P\'e1ez', 23),\
(243, 'Paz Castillo', 23),\
(244, 'Pedro Gual', 23),\
(245, 'Plaza', 23),\
(246, 'Sim\'f3n Bol\'edvar', 23),\
(247, 'Sucre', 23),\
(248, 'Urdaneta', 23),\
(249, 'Zamora', 23),\
(250, 'Acosta', 22),\
(251, 'Aguasay', 22),\
(252, 'Bol\'edvar', 22),\
(253, 'Caripe', 22),\
(254, 'Cede\'f1o', 22),\
(255, 'Ezequiel Zamora', 22),\
(256, 'Libertador', 22),\
(257, 'Matur\'edn', 22),\
(258, 'Piar', 22),\
(259, 'Punceres', 22),\
(260, 'Santa B\'e1rbara', 22),\
(261, 'Sotillo', 22),\
(262, 'Uracoa', 22),\
(263, 'Antol\'edn del Campo', 21),\
(264, 'Arismendi', 21),\
(265, 'D\'edaz', 21),\
(266, 'Garc\'eda', 21),\
(267, 'G\'f3mez', 21),\
(268, 'Maneiro', 21),\
(269, 'Marcano', 21),\
(270, 'Mari\'f1o', 21),\
(271, 'Pen\'ednsula de Macanao', 21),\
(272, 'Tubores', 21),\
(273, 'Villalba', 21),\
(274, 'Agua Blanca', 20),\
(275, 'Araure', 20),\
(276, 'Esteller', 20),\
(277, 'Guanare', 20),\
(278, 'Guanarito', 20),\
(279, 'Monse\'f1or Jos\'e9 Vicente de Unda', 20),\
(280, 'Ospino', 20),\
(281, 'P\'e1ez', 20),\
(282, 'Papel\'f3n', 20),\
(283, 'San Genaro de Bocono\'edto', 20),\
(284, 'San Rafael de Onoto', 20),\
(285, 'Santa Rosal\'eda', 20),\
(286, 'Sucre', 20),\
(287, 'Tur\'e9n', 20),\
(288, 'Andr\'e9s Eloy Blanco', 19),\
(289, 'Andr\'e9s Mata', 19),\
(290, 'Arismendi', 19),\
(291, 'Ben\'edtez', 19),\
(292, 'Berm\'fadez', 19),\
(293, 'Bol\'edvar', 19),\
(294, 'Cajigal', 19),\
(295, 'Cruz Salmer\'f3n Acosta', 19),\
(296, 'Libertador', 19),\
(297, 'Mari\'f1o', 19),\
(298, 'Mej\'eda', 19),\
(299, 'Montes', 19),\
(300, 'Ribero', 19),\
(301, 'Sucre', 19),\
(302, 'Valdez', 19),\
(303, 'Andr\'e9s Bello', 18),\
(304, 'Antonio R\'f3mulo Costa', 18),\
(305, 'Ayacucho', 18),\
(306, 'Bol\'edvar', 18),\
(307, 'C\'e1rdenas', 18),\
(308, 'C\'f3rdoba', 18),\
(309, 'Fern\'e1ndez Feo', 18),\
(310, 'Francisco de Miranda', 18),\
(311, 'Garc\'eda de Hevia', 18),\
(312, 'Gu\'e1simos', 18),\
(313, 'Independencia', 18),\
(314, 'J\'e1uregui', 18),\
(315, 'Jos\'e9 Mar\'eda Vargas', 18),\
(316, 'Jun\'edn', 18),\
(317, 'Libertad', 18),\
(318, 'Libertador', 18),\
(319, 'Lobatera', 18),\
(320, 'Michelena', 18),\
(321, 'Panamericano', 18),\
(322, 'Pedro Mar\'eda Ure\'f1a', 18),\
(323, 'Rafael Urdaneta', 18),\
(324, 'Samuel Dar\'edo Maldonado', 18),\
(325, 'San Crist\'f3bal', 18),\
(326, 'Seboruco', 18),\
(327, 'Sim\'f3n Rodr\'edguez', 18),\
(328, 'Sucre', 18),\
(329, 'Torbes', 18),\
(330, 'Uribante', 18),\
(331, 'San Judas Tadeo', 18),\
(332, 'Andr\'e9s Bello', 17),\
(333, 'Bocon\'f3', 17),\
(334, 'Bol\'edvar', 17),\
(335, 'Candelaria', 17),\
(336, 'Carache', 17),\
(337, 'Escuque', 17),\
(338, 'Jos\'e9 Felipe M\'e1rquez Ca\'f1izalez', 17),\
(339, 'Juan Vicente Campos El\'edas', 17),\
(340, 'La Ceiba', 17),\
(341, 'Miranda', 17),\
(342, 'Monte Carmelo', 17),\
(343, 'Motat\'e1n', 17),\
(344, 'Pamp\'e1n', 17),\
(345, 'Pampanito', 17),\
(346, 'Rafael Rangel', 17),\
(347, 'San Rafael de Carvajal', 17),\
(348, 'Sucre', 17),\
(349, 'Trujillo', 17),\
(350, 'Urdaneta', 17),\
(351, 'Valera', 17),\
(352, 'Vargas', 61),\
(353, 'Ar\'edstides Bastidas', 16),\
(354, 'Bol\'edvar', 16),\
(355, 'Bruzual', 16),\
(356, 'Cocorote', 16),\
(357, 'Independencia', 16),\
(358, 'Jos\'e9 Antonio P\'e1ez', 16),\
(359, 'La Trinidad', 16),\
(360, 'Manuel Monge', 16),\
(361, 'Nirgua', 16),\
(362, 'Pe\'f1a', 16),\
(363, 'San Felipe', 16),\
(364, 'Sucre', 16),\
(365, 'Urachiche', 16),\
(366, 'Veroes', 16),\
(367, 'Almirante Padilla', 38),\
(368, 'Baralt', 38),\
(369, 'Cabimas', 38),\
(370, 'Catatumbo', 38),\
(371, 'Col\'f3n', 38),\
(372, 'Francisco Javier Pulgar', 38),\
(373, 'P\'e1ez', 38),\
(374, 'Jes\'fas Enrique Lossada', 38),\
(375, 'Jes\'fas Mar\'eda Sempr\'fan', 38),\
(376, 'La Ca\'f1ada de Urdaneta', 38),\
(377, 'Lagunillas', 38),\
(378, 'Machiques de Perij\'e1', 38),\
(379, 'Mara', 38),\
(380, 'Maracaibo', 38),\
(381, 'Miranda', 38),\
(382, 'Rosario de Perij\'e1', 38),\
(383, 'San Francisco', 38),\
(384, 'Santa Rita', 38),\
(385, 'Sim\'f3n Bol\'edvar', 38),\
(386, 'Sucre', 38),\
(387, 'Valmore Rodr\'edguez', 38),\
(388, 'Libertador', 39),\
(389, 'Puerto Nari\'f1o', 65),\
(390, 'Abejorral', 43),\
(391, 'Abriaqu\'ed', 43),\
(392, 'Alejandr\'eda', 43),\
(393, 'Amag\'e1', 43),\
(394, 'Amalfi', 43),\
(395, 'Andes', 43),\
(396, 'Angel\'f3polis', 43),\
(397, 'Angostura', 43),\
(398, 'Anor\'ed', 43),\
(399, 'Anz\'e1', 43),\
(400, 'Apartad\'f3', 43),\
(401, 'Arboletes', 43),\
(402, 'Argelia', 43),\
(403, 'Armenia', 43),\
(404, 'Barbosa', 43),\
(405, 'Bello', 43),\
(406, 'Belmira', 43),\
(407, 'Betania', 43),\
(408, 'Betulia', 43),\
(409, 'Brice\'f1o', 43),\
(410, 'Buritic\'e1', 43),\
(411, 'C\'e1ceres', 43),\
(412, 'Caicedo', 43),\
(413, 'Caldas', 43),\
(414, 'Campamento', 43),\
(415, 'Ca\'f1asgordas', 43),\
(416, 'Caracol\'ed', 43),\
(417, 'Caramanta', 43),\
(418, 'Carepa', 43),\
(419, 'Carolina del Pr\'edncipe', 43),\
(420, 'Caucasia', 43),\
(421, 'Chigorod\'f3', 43),\
(422, 'Cisneros', 43),\
(423, 'Ciudad Bol\'edvar', 43),\
(424, 'Cocorn\'e1', 43),\
(425, 'Concepci\'f3n', 43),\
(426, 'Concordia', 43),\
(427, 'Copacabana', 43),\
(428, 'Dabeiba', 43),\
(429, 'Donmat\'edas', 43),\
(430, 'Eb\'e9jico', 43),\
(431, 'El Bagre', 43),\
(432, 'El Carmen de Viboral', 43),\
(433, 'El Pe\'f1ol', 43),\
(434, 'El Retiro', 43),\
(435, 'El Santuario', 43),\
(436, 'Entrerr\'edos', 43),\
(437, 'Envigado', 43),\
(438, 'Fredonia', 43),\
(439, 'Frontino', 43),\
(440, 'Giraldo', 43),\
(441, 'Girardota', 43),\
(442, 'G\'f3mez Plata', 43),\
(443, 'Granada', 43),\
(444, 'Guadalupe', 43),\
(445, 'Guarne', 43),\
(446, 'Guatap\'e9', 43),\
(447, 'Heliconia', 43),\
(448, 'Hispania', 43),\
(449, 'Itag\'fc\'ed', 43),\
(450, 'Ituango', 43),\
(451, 'Jard\'edn', 43),\
(452, 'Jeric\'f3', 43),\
(453, 'La Ceja', 43),\
(454, 'La Estrella', 43),\
(455, 'La Pintada', 43),\
(456, 'La Uni\'f3n', 43),\
(457, 'Liborina', 43),\
(458, 'Maceo', 43),\
(459, 'Marinilla', 43),\
(460, 'Medell\'edn', 43),\
(461, 'Montebello', 43),\
(462, 'Murind\'f3', 43),\
(463, 'Mutat\'e1', 43),\
(464, 'Nari\'f1o', 43),\
(465, 'Nech\'ed', 43),\
(466, 'Necocl\'ed', 43),\
(467, 'Olaya', 43),\
(468, 'Peque', 43),\
(469, 'Pueblorrico', 43),\
(470, 'Puerto Berr\'edo', 43),\
(471, 'Puerto Nare', 43),\
(472, 'Puerto Triunfo', 43),\
(473, 'Remedios', 43),\
(474, 'Rionegro', 43),\
(475, 'Sabanalarga', 43),\
(476, 'Sabaneta', 43),\
(477, 'Salgar', 43),\
(478, 'San Andr\'e9s de Cuerquia', 43),\
(479, 'San Carlos', 43),\
(480, 'San Francisco', 43),\
(481, 'San Jer\'f3nimo', 43),\
(482, 'San Jos\'e9 de la Monta\'f1a', 43),\
(483, 'San Juan de Urab\'e1', 43),\
(484, 'San Luis', 43),\
(485, 'San Pedro de Urab\'e1', 43),\
(486, 'San Pedro de los Milagros', 43),\
(487, 'San Rafael', 43),\
(488, 'San Roque', 43),\
(489, 'San Vicente', 43),\
(490, 'Santa B\'e1rbara', 43),\
(491, 'Santa Fe de Antioquia', 43),\
(492, 'Santa Rosa de Osos', 43),\
(493, 'Santo Domingo', 43),\
(494, 'Segovia', 43),\
(495, 'Sons\'f3n', 43),\
(496, 'Sopetr\'e1n', 43),\
(497, 'T\'e1mesis', 43),\
(498, 'Taraz\'e1', 43),\
(499, 'Tarso', 43),\
(500, 'Titirib\'ed', 43),\
(501, 'Toledo', 43),\
(502, 'Turbo', 43),\
(503, 'Uramita', 43),\
(504, 'Urrao', 43),\
(505, 'Valdivia', 43),\
(506, 'Valpara\'edso', 43),\
(507, 'Vegach\'ed', 43),\
(508, 'Venecia', 43),\
(509, 'Vig\'eda del Fuerte', 43),\
(510, 'Yal\'ed', 43),\
(511, 'Yarumal', 43),\
(512, 'Yolomb\'f3', 43),\
(513, 'Yond\'f3', 43),\
(514, 'Zaragoza', 43),\
(515, 'Arauca', 42),\
(516, 'Arauquita', 42),\
(517, 'Cravo Norte', 42),\
(518, 'Fortul', 42),\
(519, 'Puerto Rond\'f3n', 42),\
(520, 'Saravena', 42),\
(521, 'Tame', 42),\
(522, 'Baranoa', 43),\
(523, 'Barranquilla', 43),\
(524, 'Campo de la Cruz', 43),\
(525, 'Candelaria', 43),\
(526, 'Galapa', 43),\
(527, 'Juan de Acosta', 43),\
(528, 'Luruaco', 43),\
(529, 'Malambo', 43),\
(530, 'Manat\'ed', 43),\
(531, 'Palmar de Varela', 43),\
(532, 'Pioj\'f3', 43),\
(533, 'Polonuevo', 43),\
(534, 'Ponedera', 43),\
(535, 'Puerto Colombia', 43),\
(536, 'Repel\'f3n', 43),\
(537, 'Sabanagrande', 43),\
(538, 'Sabanalarga', 43),\
(539, 'Santa Luc\'eda', 43),\
(540, 'Santo Tom\'e1s', 43),\
(541, 'Soledad', 43),\
(542, 'Su\'e1n', 43),\
(543, 'Tubar\'e1', 43),\
(544, 'Usiacur\'ed', 43),\
(545, 'Ach\'ed', 44),\
(546, 'Altos del Rosario', 44),\
(547, 'Arenal', 44),\
(548, 'Arjona', 44),\
(549, 'Arroyohondo', 44),\
(550, 'Barranco de Loba', 44),\
(551, 'Brazuelo de Papayal', 44),\
(552, 'Calamar', 44),\
(553, 'Cantagallo', 44),\
(554, 'Cartagena de Indias', 44),\
(555, 'Cicuco', 44),\
(556, 'Clemencia', 44),\
(557, 'C\'f3rdoba', 44),\
(558, 'El Carmen de Bol\'edvar', 44),\
(559, 'El Guamo', 44),\
(560, 'El Pe\'f1\'f3n', 44),\
(561, 'Hatillo de Loba', 44),\
(562, 'Magangu\'e9', 44),\
(563, 'Mahates', 44),\
(564, 'Margarita', 44),\
(565, 'Mar\'eda la Baja', 44),\
(566, 'Momp\'f3s', 44),\
(567, 'Montecristo', 44),\
(568, 'Morales', 44),\
(569, 'Noros\'ed', 44),\
(570, 'Pinillos', 44),\
(571, 'Regidor', 44),\
(572, 'R\'edo Viejo', 44),\
(573, 'San Crist\'f3bal', 44),\
(574, 'San Estanislao', 44),\
(575, 'San Fernando', 44),\
(576, 'San Jacinto del Cauca', 44),\
(577, 'San Jacinto', 44),\
(578, 'San Juan Nepomuceno', 44),\
(579, 'San Mart\'edn de Loba', 44),\
(580, 'San Pablo', 44),\
(581, 'Santa Catalina', 44),\
(582, 'Santa Rosa', 44),\
(583, 'Santa Rosa del Sur', 44),\
(584, 'Simit\'ed', 44),\
(585, 'Soplaviento', 44),\
(586, 'Talaigua Nuevo', 44),\
(587, 'Tiquisio', 44),\
(588, 'Turbaco', 44),\
(589, 'Turban\'e1', 44),\
(590, 'Villanueva', 44),\
(591, 'Zambrano', 44),\
(592, 'Almeida', 45),\
(593, 'Aquitania', 45),\
(594, 'Arcabuco', 45),\
(595, 'Bel\'e9n', 45),\
(596, 'Berbeo', 45),\
(597, 'Bet\'e9itiva', 45),\
(598, 'Boavita', 45),\
(599, 'Boyac\'e1', 45),\
(600, 'Brice\'f1o', 45),\
(601, 'Buenavista', 45),\
(602, 'Busbanz\'e1', 45),\
(603, 'Caldas', 45),\
(604, 'Campohermoso', 45),\
(605, 'Cerinza', 45),\
(606, 'Chinavita', 45),\
(607, 'Chiquinquir\'e1', 45),\
(608, 'Ch\'edquiza', 45),\
(609, 'Chiscas', 45),\
(610, 'Chita', 45),\
(611, 'Chitaraque', 45),\
(612, 'Chivat\'e1', 45),\
(613, 'Chivor', 45),\
(614, 'Ci\'e9nega', 45),\
(615, 'C\'f3mbita', 45),\
(616, 'Coper', 45),\
(617, 'Corrales', 45),\
(618, 'Covarach\'eda', 45),\
(619, 'Cubar\'e1', 45),\
(620, 'Cucaita', 45),\
(621, 'Cu\'edtiva', 45),\
(622, 'Duitama', 45),\
(623, 'El Cocuy', 45),\
(624, 'El Espino', 45),\
(625, 'Firavitoba', 45),\
(626, 'Floresta', 45),\
(627, 'Gachantiv\'e1', 45),\
(628, 'G\'e1meza', 45),\
(629, 'Garagoa', 45),\
(630, 'Guacamayas', 45),\
(631, 'Guateque', 45),\
(632, 'Guayat\'e1', 45),\
(633, 'G\'fcic\'e1n', 45),\
(634, 'Iza', 45),\
(635, 'Jenesano', 45),\
(636, 'Jeric\'f3', 45),\
(637, 'La Capilla', 45),\
(638, 'La Uvita', 45),\
(639, 'La Victoria', 45),\
(640, 'Labranzagrande', 45),\
(641, 'Macanal', 45),\
(642, 'Marip\'ed', 45),\
(643, 'Miraflores', 45),\
(644, 'Mongua', 45),\
(645, 'Mongu\'ed', 45),\
(646, 'Moniquir\'e1', 45),\
(647, 'Motavita', 45),\
(648, 'Muzo', 45),\
(649, 'Nobsa', 45),\
(650, 'Nuevo Col\'f3n', 45),\
(651, 'Oicat\'e1', 45),\
(652, 'Otanche', 45),\
(653, 'Pachavita', 45),\
(654, 'P\'e1ez', 45),\
(655, 'Paipa', 45),\
(656, 'Pajarito', 45),\
(657, 'Panqueba', 45),\
(658, 'Pauna', 45),\
(659, 'Paya', 45),\
(660, 'Paz del R\'edo', 45),\
(661, 'Pesca', 45),\
(662, 'Pisba', 45),\
(663, 'Puerto Boyac\'e1', 45),\
(664, 'Qu\'edpama', 45),\
(665, 'Ramiriqu\'ed', 45),\
(666, 'R\'e1quira', 45),\
(667, 'Rond\'f3n', 45),\
(668, 'Saboy\'e1', 45),\
(669, 'S\'e1chica', 45),\
(670, 'Samac\'e1', 45),\
(671, 'San Eduardo', 45),\
(672, 'San Jos\'e9 de Pare', 45),\
(673, 'San Luis de Gaceno', 45),\
(674, 'San Mateo', 45),\
(675, 'San Miguel de Sema', 45),\
(676, 'San Pablo de Borbur', 45),\
(677, 'Santa Mar\'eda', 45),\
(678, 'Santa Rosa de Viterbo', 45),\
(679, 'Santa Sof\'eda', 45),\
(680, 'Santana', 45),\
(681, 'Sativanorte', 45),\
(682, 'Sativasur', 45),\
(683, 'Siachoque', 45),\
(684, 'Soat\'e1', 45),\
(685, 'Socha', 45),\
(686, 'Socot\'e1', 45),\
(687, 'Sogamoso', 45),\
(688, 'Somondoco', 45),\
(689, 'Sora', 45),\
(690, 'Sorac\'e1', 45),\
(691, 'Sotaquir\'e1', 45),\
(692, 'Susac\'f3n', 45),\
(693, 'Sutamarch\'e1n', 45),\
(694, 'Sutatenza', 45),\
(695, 'Tasco', 45),\
(696, 'Tenza', 45),\
(697, 'Tiban\'e1', 45),\
(698, 'Tibasosa', 45),\
(699, 'Tinjac\'e1', 45),\
(700, 'Tipacoque', 45),\
(701, 'Toca', 45),\
(702, 'Tog\'fc\'ed', 45),\
(703, 'T\'f3paga', 45),\
(704, 'Tota', 45),\
(705, 'Tunja', 45),\
(706, 'Tunungu\'e1', 45),\
(707, 'Turmequ\'e9', 45),\
(708, 'Tuta', 45),\
(709, 'Tutaz\'e1', 45),\
(710, '\'dambita', 45),\
(711, 'Ventaquemada', 45),\
(712, 'Villa de Leyva', 45),\
(713, 'Viracach\'e1', 45),\
(714, 'Zetaquira', 45),\
(715, 'Aguadas', 46),\
(716, 'Anserma', 46),\
(717, 'Aranzazu', 46),\
(718, 'Belalc\'e1zar', 46),\
(719, 'Chinchin\'e1', 46),\
(720, 'Filadelfia', 46),\
(721, 'La Dorada', 46),\
(722, 'La Merced', 46),\
(723, 'Manizales', 46),\
(724, 'Manzanares', 46),\
(725, 'Marmato', 46),\
(726, 'Marquetalia', 46),\
(727, 'Marulanda', 46),\
(728, 'Neira', 46),\
(729, 'Norcasia', 46),\
(730, 'P\'e1cora', 46),\
(731, 'Palestina', 46),\
(732, 'Pensilvania', 46),\
(733, 'Riosucio', 46),\
(734, 'Risaralda', 46),\
(735, 'Salamina', 46),\
(736, 'Saman\'e1', 46),\
(737, 'San Jos\'e9', 46),\
(738, 'Sup\'eda', 46),\
(739, 'Victoria', 46),\
(740, 'Villamar\'eda', 46),\
(741, 'Viterbo', 46),\
(742, 'Albania', 47),\
(743, 'Bel\'e9n de los Andaqu\'edes', 47),\
(744, 'Cartagena del Chair\'e1', 47),\
(745, 'Curillo', 47),\
(746, 'El Doncello', 47),\
(747, 'El Paujil', 47),\
(748, 'Florencia', 47),\
(749, 'La Monta\'f1ita', 47),\
(750, 'Mil\'e1n', 47),\
(751, 'Morelia', 47),\
(752, 'Puerto Rico', 47),\
(753, 'San Jos\'e9 del Fragua', 47),\
(754, 'San Vicente del Cagu\'e1n', 47),\
(755, 'Solano', 47),\
(756, 'Solita', 47),\
(757, 'Valpara\'edso', 47),\
(758, 'Aguazul', 48),\
(759, 'Ch\'e1meza', 48),\
(760, 'Hato Corozal', 48),\
(761, 'La Salina', 48),\
(762, 'Man\'ed', 48),\
(763, 'Monterrey', 48),\
(764, 'Nunch\'eda', 48),\
(765, 'Orocu\'e9', 48),\
(766, 'Paz de Ariporo', 48),\
(767, 'Pore', 48),\
(768, 'Recetor', 48),\
(769, 'Sabanalarga', 48),\
(770, 'S\'e1cama', 48),\
(771, 'San Luis de Palenque', 48),\
(772, 'T\'e1mara', 48),\
(773, 'Tauramena', 48),\
(774, 'Trinidad', 48),\
(775, 'Villanueva', 48),\
(776, 'Yopal', 48),\
(777, 'Almaguer', 49),\
(778, 'Argelia', 49),\
(779, 'Balboa', 49),\
(780, 'Bol\'edvar', 49),\
(781, 'Buenos Aires', 49),\
(782, 'Cajib\'edo', 49),\
(783, 'Caldono', 49),\
(784, 'Caloto', 49),\
(785, 'Corinto', 49),\
(786, 'El Tambo', 49),\
(787, 'Florencia', 49),\
(788, 'Guachen\'e9', 49),\
(789, 'Guap\'ed', 49),\
(790, 'Inz\'e1', 49),\
(791, 'Jambal\'f3', 49),\
(792, 'La Sierra', 49),\
(793, 'La Vega', 49),\
(794, 'L\'f3pez de Micay', 49),\
(795, 'Mercaderes', 49),\
(796, 'Miranda', 49),\
(797, 'Morales', 49),\
(798, 'Padilla', 49),\
(799, 'P\'e1ez', 49),\
(800, 'Pat\'eda', 49),\
(801, 'Piamonte', 49),\
(802, 'Piendam\'f3', 49),\
(803, 'Popay\'e1n', 49),\
(804, 'Puerto Tejada', 49),\
(805, 'Purac\'e9', 49),\
(806, 'Rosas', 49),\
(807, 'San Sebasti\'e1n', 49),\
(808, 'Santa Rosa', 49),\
(809, 'Santander de Quilichao', 49),\
(810, 'Silvia', 49),\
(811, 'Sotar\'e1', 49),\
(812, 'Su\'e1rez', 49),\
(813, 'Sucre', 49),\
(814, 'Timb\'edo', 49),\
(815, 'Timbiqu\'ed', 49),\
(816, 'Torib\'edo', 49),\
(817, 'Totor\'f3', 49),\
(818, 'Villa Rica', 49),\
(819, 'Aguachica', 50),\
(820, 'Agust\'edn Codazzi', 50),\
(821, 'Astrea', 50),\
(822, 'Becerril', 50),\
(823, 'Bosconia', 50),\
(824, 'Chimichagua', 50),\
(825, 'Chiriguan\'e1', 50),\
(826, 'Curuman\'ed', 50),\
(827, 'El Copey', 50),\
(828, 'El Paso', 50),\
(829, 'Gamarra', 50),\
(830, 'Gonz\'e1lez', 50),\
(831, 'La Gloria (Cesar)', 50),\
(832, 'La Jagua de Ibirico', 50),\
(833, 'La Paz', 50),\
(834, 'Manaure Balc\'f3n del Cesar', 50),\
(835, 'Pailitas', 50),\
(836, 'Pelaya', 50),\
(837, 'Pueblo Bello', 50),\
(838, 'R\'edo de Oro', 50),\
(839, 'San Alberto', 50),\
(840, 'San Diego', 50),\
(841, 'San Mart\'edn', 50),\
(842, 'Tamalameque', 50),\
(843, 'Valledupar', 50),\
(844, 'Acand\'ed', 51),\
(845, 'Alto Baud\'f3', 51),\
(846, 'Bagad\'f3', 51),\
(847, 'Bah\'eda Solano', 51),\
(848, 'Bajo Baud\'f3', 51),\
(849, 'Bojay\'e1', 51),\
(850, 'Cant\'f3n de San Pablo', 51),\
(851, 'C\'e9rtegui', 51),\
(852, 'Condoto', 51),\
(853, 'El Atrato', 51),\
(854, 'El Carmen de Atrato', 51),\
(855, 'El Carmen del Dari\'e9n', 51),\
(856, 'Istmina', 51),\
(857, 'Jurad\'f3', 51),\
(858, 'Litoral de San Juan', 51),\
(859, 'Llor\'f3', 51),\
(860, 'Medio Atrato', 51),\
(861, 'Medio Baud\'f3', 51),\
(862, 'Medio San Juan', 51),\
(863, 'N\'f3vita', 51),\
(864, 'Nuqu\'ed', 51),\
(865, 'Quibd\'f3', 51),\
(866, 'R\'edo Ir\'f3', 51),\
(867, 'R\'edo Quito', 51),\
(868, 'Riosucio', 51),\
(869, 'San Jos\'e9 del Palmar', 51),\
(870, 'Sip\'ed', 51),\
(871, 'Tad\'f3', 51),\
(872, 'Uni\'f3n Panamericana', 51),\
(873, 'Ungu\'eda', 51),\
(874, 'Agua de Dios', 52),\
(875, 'Alb\'e1n', 52),\
(876, 'Anapoima', 52),\
(877, 'Anolaima', 52),\
(878, 'Apulo', 52),\
(879, 'Arbel\'e1ez', 52),\
(880, 'Beltr\'e1n', 52),\
(881, 'Bituima', 52),\
(882, 'Bogot\'e1', 52),\
(883, 'Bojac\'e1', 52),\
(884, 'Cabrera', 52),\
(885, 'Cachipay', 52),\
(886, 'Cajic\'e1', 52),\
(887, 'Caparrap\'ed', 52),\
(888, 'C\'e1queza', 52),\
(889, 'Carmen de Carupa', 52),\
(890, 'Chaguan\'ed', 52),\
(891, 'Ch\'eda', 52),\
(892, 'Chipaque', 52),\
(893, 'Choach\'ed', 52),\
(894, 'Chocont\'e1', 52),\
(895, 'Cogua', 52),\
(896, 'Cota', 52),\
(897, 'Cucunub\'e1', 52),\
(898, 'El Colegio', 52),\
(899, 'El Pe\'f1\'f3n', 52),\
(900, 'El Rosal', 52),\
(901, 'Facatativ\'e1', 52),\
(902, 'F\'f3meque', 52),\
(903, 'Fosca', 52),\
(904, 'Funza', 52),\
(905, 'F\'faquene', 52),\
(906, 'Fusagasug\'e1', 52),\
(907, 'Gachal\'e1', 52),\
(908, 'Gachancip\'e1', 52),\
(909, 'Gachet\'e1', 52),\
(910, 'Gama', 52),\
(911, 'Girardot', 52),\
(912, 'Granada', 52),\
(913, 'Guachet\'e1', 52),\
(914, 'Guaduas', 52),\
(915, 'Guasca', 52),\
(916, 'Guataqu\'ed', 52),\
(917, 'Guatavita', 52),\
(918, 'Guayabal de S\'edquima', 52),\
(919, 'Guayabetal', 52),\
(920, 'Guti\'e9rrez', 52),\
(921, 'Jerusal\'e9n', 52),\
(922, 'Jun\'edn', 52),\
(923, 'La Calera', 52),\
(924, 'La Mesa', 52),\
(925, 'La Palma', 52),\
(926, 'La Pe\'f1a', 52),\
(927, 'La Vega', 52),\
(928, 'Lenguazaque', 52),\
(929, 'Machet\'e1', 52),\
(930, 'Madrid', 52),\
(931, 'Manta', 52),\
(932, 'Medina', 52),\
(933, 'Mosquera', 52),\
(934, 'Nari\'f1o', 52),\
(935, 'Nemoc\'f3n', 52),\
(936, 'Nilo', 52),\
(937, 'Nimaima', 52),\
(938, 'Nocaima', 52),\
(939, 'Pacho', 52),\
(940, 'Paime', 52),\
(941, 'Pandi', 52),\
(942, 'Paratebueno', 52),\
(943, 'Pasca', 52),\
(944, 'Puerto Salgar', 52),\
(945, 'Pul\'ed', 52),\
(946, 'Quebradanegra', 52),\
(947, 'Quetame', 52),\
(948, 'Quipile', 52),\
(949, 'Ricaurte', 52),\
(950, 'San Antonio del Tequendama', 52),\
(951, 'San Bernardo', 52),\
(952, 'San Cayetano', 52),\
(953, 'San Francisco', 52),\
(954, 'San Juan de Rioseco', 52),\
(955, 'Sasaima', 52),\
(956, 'Sesquil\'e9', 52),\
(957, 'Sibat\'e9', 52),\
(958, 'Silvania', 52),\
(959, 'Simijaca', 52),\
(960, 'Soacha', 52),\
(961, 'Sop\'f3', 52),\
(962, 'Subachoque', 52),\
(963, 'Suesca', 52),\
(964, 'Supat\'e1', 52),\
(965, 'Susa', 52),\
(966, 'Sutatausa', 52),\
(967, 'Tabio', 52),\
(968, 'Tausa', 52),\
(969, 'Tena', 52),\
(970, 'Tenjo', 52),\
(971, 'Tibacuy', 52),\
(972, 'Tibirita', 52),\
(973, 'Tocaima', 52),\
(974, 'Tocancip\'e1', 52),\
(975, 'Topaip\'ed', 52),\
(976, 'Ubal\'e1', 52),\
(977, 'Ubaque', 52),\
(978, 'Ubat\'e9', 52),\
(979, 'Une', 52),\
(980, '\'datica', 52),\
(981, 'Venecia', 52),\
(982, 'Vergara', 52),\
(983, 'Vian\'ed', 52),\
(984, 'Villag\'f3mez', 52),\
(985, 'Villapinz\'f3n', 52),\
(986, 'Villeta', 52),\
(987, 'Viot\'e1', 52),\
(988, 'Yacop\'ed', 52),\
(989, 'Zipac\'f3n', 52),\
(990, 'Zipaquir\'e1', 52),\
(991, 'Ayapel', 53),\
(992, 'Buenavista', 53),\
(993, 'Canalete', 53),\
(994, 'Ceret\'e9', 53),\
(995, 'Chim\'e1', 53),\
(996, 'Chin\'fa', 53),\
(997, 'Ci\'e9naga de Oro', 53),\
(998, 'Cotorra', 53),\
(999, 'La Apartada', 53),\
(1000, 'Lorica', 53),\
(1001, 'Los C\'f3rdobas', 53),\
(1002, 'Momil', 53),\
(1003, 'Montel\'edbano', 53),\
(1004, 'Monter\'eda', 53),\
(1005, 'Mo\'f1itos', 53),\
(1006, 'Planeta Rica', 53),\
(1007, 'Pueblo Nuevo', 53),\
(1008, 'Puerto Escondido', 53),\
(1009, 'Puerto Libertador', 53),\
(1010, 'Pur\'edsima', 53),\
(1011, 'Sahag\'fan', 53),\
(1012, 'San Andr\'e9s de Sotavento', 53),\
(1013, 'San Antero', 53),\
(1014, 'San Bernardo del Viento', 53),\
(1015, 'San Carlos', 53),\
(1016, 'San Jos\'e9 de Ur\'e9', 53),\
(1017, 'San Pelayo', 53),\
(1018, 'Tierralta', 53),\
(1019, 'Tuch\'edn', 53),\
(1020, 'Valencia', 53),\
(1021, 'In\'edrida', 54),\
(1022, 'Calamar', 55),\
(1023, 'El Retorno', 55),\
(1024, 'Miraflores', 55),\
(1025, 'San Jos\'e9 del Guaviare', 55),\
(1026, 'Acevedo', 56),\
(1027, 'Agrado', 56),\
(1028, 'Aipe', 56),\
(1029, 'Algeciras', 56),\
(1030, 'Altamira', 56),\
(1031, 'Baraya', 56),\
(1032, 'Campoalegre', 56),\
(1033, 'Colombia', 56),\
(1034, 'El Pital', 56),\
(1035, 'El\'edas', 56),\
(1036, 'Garz\'f3n', 56),\
(1037, 'Gigante', 56),\
(1038, 'Guadalupe', 56),\
(1039, 'Hobo', 56),\
(1040, '\'cdquira', 56),\
(1041, 'Isnos', 56),\
(1042, 'La Argentina', 56),\
(1043, 'La Plata', 56),\
(1044, 'N\'e1taga', 56),\
(1045, 'Neiva', 56),\
(1046, 'Oporapa', 56),\
(1047, 'Paicol', 56),\
(1048, 'Palermo', 56),\
(1049, 'Palestina', 56),\
(1050, 'Pitalito', 56),\
(1051, 'Rivera', 56),\
(1052, 'Saladoblanco', 56),\
(1053, 'San Agust\'edn', 56),\
(1054, 'Santa Mar\'eda', 56),\
(1055, 'Suaza', 56),\
(1056, 'Tarqui', 56),\
(1057, 'Tello', 56),\
(1058, 'Teruel', 56),\
(1059, 'Tesalia', 56),\
(1060, 'Timan\'e1', 56),\
(1061, 'Villavieja', 56),\
(1062, 'Yaguar\'e1', 56),\
(1063, 'Albania', 57),\
(1064, 'Barrancas', 57),\
(1065, 'Dibulla', 57),\
(1066, 'Distracci\'f3n', 57),\
(1067, 'El Molino', 57),\
(1068, 'Fonseca', 57),\
(1069, 'Hatonuevo', 57),\
(1070, 'La Jagua del Pilar', 57),\
(1071, 'Maicao', 57),\
(1072, 'Manaure', 57),\
(1073, 'Riohacha', 57),\
(1074, 'San Juan del Cesar', 57),\
(1075, 'Uribia', 57),\
(1076, 'Urumita', 57),\
(1077, 'Villanueva', 57),\
(1078, 'Algarrobo', 58),\
(1079, 'Aracataca', 58),\
(1080, 'Ariguan\'ed', 58),\
(1081, 'Cerro de San Antonio', 58),\
(1082, 'Chibolo', 58),\
(1083, 'Chibolo', 58),\
(1084, 'Ci\'e9naga', 58),\
(1085, 'Concordia', 58),\
(1086, 'El Banco', 58),\
(1087, 'El Pi\'f1\'f3n', 58),\
(1088, 'El Ret\'e9n', 58),\
(1089, 'Fundaci\'f3n', 58),\
(1090, 'Guamal', 58),\
(1091, 'Nueva Granada', 58),\
(1092, 'Pedraza', 58),\
(1093, 'Piji\'f1o del Carmen', 58),\
(1094, 'Pivijay', 58),\
(1095, 'Plato', 58),\
(1096, 'Pueblo Viejo', 58),\
(1097, 'Remolino', 58),\
(1098, 'Sabanas de San \'c1ngel', 58),\
(1099, 'Salamina', 58),\
(1100, 'San Sebasti\'e1n de Buenavista', 58),\
(1101, 'San Zen\'f3n', 58),\
(1102, 'Santa Ana', 58),\
(1103, 'Santa B\'e1rbara de Pinto', 58),\
(1104, 'Santa Marta', 58),\
(1105, 'Sitionuevo', 58),\
(1106, 'Tenerife', 58),\
(1107, 'Zapay\'e1n', 58),\
(1108, 'Zona Bananera', 58),\
(1109, 'Acac\'edas', 59),\
(1110, 'Barranca de Up\'eda', 59),\
(1111, 'Cabuyaro', 59),\
(1112, 'Castilla la Nueva', 59),\
(1113, 'Cubarral', 59),\
(1114, 'Cumaral', 59),\
(1115, 'El Calvario', 59),\
(1116, 'El Castillo', 59),\
(1117, 'El Dorado', 59),\
(1118, 'Fuente de Oro', 59),\
(1119, 'Granada', 59),\
(1120, 'Guamal', 59),\
(1121, 'La Macarena', 59),\
(1122, 'La Uribe', 59),\
(1123, 'Lejan\'edas', 59),\
(1124, 'Mapirip\'e1n', 59),\
(1125, 'Mesetas', 59),\
(1126, 'Puerto Concordia', 59),\
(1127, 'Puerto Gait\'e1n', 59),\
(1128, 'Puerto Lleras', 59),\
(1129, 'Puerto L\'f3pez', 59),\
(1130, 'Puerto Rico', 59),\
(1131, 'Restrepo', 59),\
(1132, 'San Carlos de Guaroa', 59),\
(1133, 'San Juan de Arama', 59),\
(1134, 'San Juanito', 59),\
(1135, 'San Mart\'edn', 59),\
(1136, 'Villavicencio', 59),\
(1137, 'Vista Hermosa', 59),\
(1138, 'Aldana', 60),\
(1139, 'Ancuy\'e1', 60),\
(1140, 'Arboleda', 60),\
(1141, 'Barbacoas', 60),\
(1142, 'Bel\'e9n', 60),\
(1143, 'Buesaco', 60),\
(1144, 'Chachag\'fc\'ed', 60),\
(1145, 'Col\'f3n', 60),\
(1146, 'Consac\'e1', 60),\
(1147, 'Contadero', 60),\
(1148, 'C\'f3rdoba', 60),\
(1149, 'Cuaspud', 60),\
(1150, 'Cumbal', 60),\
(1151, 'Cumbitara', 60),\
(1152, 'El Charco', 60),\
(1153, 'El Pe\'f1ol', 60),\
(1154, 'El Rosario', 60),\
(1155, 'El Tabl\'f3n', 60),\
(1156, 'El Tambo', 60),\
(1157, 'Francisco Pizarro', 60),\
(1158, 'Funes', 60),\
(1159, 'Guachucal', 60),\
(1160, 'Guaitarilla', 60),\
(1161, 'Gualmat\'e1n', 60),\
(1162, 'Iles', 60),\
(1163, 'Imu\'e9s', 60),\
(1164, 'Ipiales', 60),\
(1165, 'La Cruz', 60),\
(1166, 'La Florida', 60),\
(1167, 'La Llanada', 60),\
(1168, 'La Tola', 60),\
(1169, 'La Uni\'f3n', 60),\
(1170, 'Leiva', 60),\
(1171, 'Linares', 60),\
(1172, 'Los Andes', 60),\
(1173, 'Mag\'fc\'ed Pay\'e1n', 60),\
(1174, 'Mallama', 60),\
(1175, 'Mosquera', 60),\
(1176, 'Nari\'f1o', 60),\
(1177, 'Olaya Herrera', 60),\
(1178, 'Ospina', 60),\
(1179, 'Pasto', 60),\
(1180, 'Policarpa', 60),\
(1181, 'Potos\'ed', 60),\
(1182, 'Providencia', 60),\
(1183, 'Puerres', 60),\
(1184, 'Pupiales', 60),\
(1185, 'Ricaurte', 60),\
(1186, 'Roberto Pay\'e1n', 60),\
(1187, 'Samaniego', 60),\
(1188, 'San Bernardo', 60),\
(1189, 'San Jos\'e9 de Alb\'e1n', 60),\
(1190, 'San Lorenzo', 60),\
(1191, 'San Pablo', 60),\
(1192, 'San Pedro de Cartago', 60),\
(1193, 'Sandon\'e1', 60),\
(1194, 'Santa B\'e1rbara', 60),\
(1195, 'Santacruz', 60),\
(1196, 'Sapuyes', 60),\
(1197, 'Taminango', 60),\
(1198, 'Tangua', 60),\
(1199, 'Tumaco', 60),\
(1200, 'T\'faquerres', 60),\
(1201, 'Yacuanquer', 60),\
(1202, '\'c1brego', 61),\
(1203, 'Arboledas', 61),\
(1204, 'Bochalema', 61),\
(1205, 'Bucarasica', 61),\
(1206, 'C\'e1chira', 61),\
(1207, 'C\'e1cota', 61),\
(1208, 'Chin\'e1cota', 61),\
(1209, 'Chitag\'e1', 61),\
(1210, 'Convenci\'f3n', 61),\
(1211, 'C\'facuta', 61),\
(1212, 'Cucutilla', 61),\
(1213, 'Duran\'eda', 61),\
(1214, 'El Carmen', 61),\
(1215, 'El Tarra', 61),\
(1216, 'El Zulia', 61),\
(1217, 'Gramalote', 61),\
(1218, 'Hacar\'ed', 61),\
(1219, 'Herr\'e1n', 61),\
(1220, 'La Esperanza', 61),\
(1221, 'La Playa de Bel\'e9n', 61),\
(1222, 'Labateca', 61),\
(1223, 'Los Patios', 61),\
(1224, 'Lourdes', 61),\
(1225, 'Mutiscua', 61),\
(1226, 'Oca\'f1a', 61),\
(1227, 'Pamplona', 61),\
(1228, 'Pamplonita', 61),\
(1229, 'Puerto Santander', 61),\
(1230, 'Ragonvalia', 61),\
(1231, 'Salazar de Las Palmas', 61),\
(1232, 'San Calixto', 61),\
(1233, 'San Cayetano', 61),\
(1234, 'Santiago', 61),\
(1235, 'Santo Domingo de Silos', 61),\
(1236, 'Sardinata', 61),\
(1237, 'Teorama', 61),\
(1238, 'Tib\'fa', 61),\
(1239, 'Toledo', 61),\
(1240, 'Villa Caro', 61),\
(1241, 'Villa del Rosario', 61),\
(1242, 'Col\'f3n', 62),\
(1243, 'Mocoa', 62),\
(1244, 'Orito', 62),\
(1245, 'Puerto As\'eds', 62),\
(1246, 'Puerto Caicedo', 62),\
(1247, 'Puerto Guzm\'e1n', 62),\
(1248, 'Puerto Legu\'edzamo', 62),\
(1249, 'San Francisco', 62),\
(1250, 'San Miguel', 62),\
(1251, 'Santiago', 62),\
(1252, 'Sibundoy', 62),\
(1253, 'Valle del Guamuez', 62),\
(1254, 'Villagarz\'f3n', 62),\
(1255, 'Armenia', 63),\
(1256, 'Buenavista', 63),\
(1257, 'Calarc\'e1', 63),\
(1258, 'Circasia', 63),\
(1259, 'C\'f3rdoba', 63),\
(1260, 'Filandia', 63),\
(1261, 'G\'e9nova', 63),\
(1262, 'La Tebaida', 63),\
(1263, 'Montenegro', 63),\
(1264, 'Pijao', 63),\
(1265, 'Quimbaya', 63),\
(1266, 'Salento', 63),\
(1267, 'Ap\'eda', 64),\
(1268, 'Balboa', 64),\
(1269, 'Bel\'e9n de Umbr\'eda', 64),\
(1270, 'Dosquebradas', 64),\
(1271, 'Gu\'e1tica', 64),\
(1272, 'La Celia', 64),\
(1273, 'La Virginia', 64),\
(1274, 'Marsella', 64),\
(1275, 'Mistrat\'f3', 64),\
(1276, 'Pereira', 64),\
(1277, 'Pueblo Rico', 64),\
(1278, 'Quinch\'eda', 64),\
(1279, 'Santa Rosa de Cabal', 64),\
(1280, 'Santuario', 64),\
(1281, 'Providencia y Santa Catalina Islas', 65),\
(1282, 'San Andr\'e9s', 65),\
(1283, 'Aguada', 66),\
(1284, 'Albania', 66),\
(1285, 'Aratoca', 66),\
(1286, 'Barbosa', 66),\
(1287, 'Barichara', 66),\
(1288, 'Barrancabermeja', 66),\
(1289, 'Betulia', 66),\
(1290, 'Bol\'edvar', 66),\
(1291, 'Bucaramanga', 66),\
(1292, 'Cabrera', 66),\
(1293, 'California', 66),\
(1294, 'Capitanejo', 66),\
(1295, 'Carcas\'ed', 66),\
(1296, 'Cepit\'e1', 66),\
(1297, 'Cerrito', 66),\
(1298, 'Charal\'e1', 66),\
(1299, 'Charta', 66),\
(1300, 'Chima', 66),\
(1301, 'Chipat\'e1', 66),\
(1302, 'Cimitarra', 66),\
(1303, 'Concepci\'f3n', 66),\
(1304, 'Confines', 66),\
(1305, 'Contrataci\'f3n', 66),\
(1306, 'Coromoro', 66),\
(1307, 'Curit\'ed', 66),\
(1308, 'El Carmen de Chucur\'ed', 66),\
(1309, 'El Guacamayo', 66),\
(1310, 'El Pe\'f1\'f3n', 66),\
(1311, 'El Play\'f3n', 66),\
(1312, 'El Socorro', 66),\
(1313, 'Encino', 66),\
(1314, 'Enciso', 66),\
(1315, 'Flori\'e1n', 66),\
(1316, 'Floridablanca', 66),\
(1317, 'Gal\'e1n', 66),\
(1318, 'G\'e1mbita', 66),\
(1319, 'Gir\'f3n', 66),\
(1320, 'Guaca', 66),\
(1321, 'Guadalupe', 66),\
(1322, 'Guapot\'e1', 66),\
(1323, 'Guavat\'e1', 66),\
(1324, 'G\'fcepsa', 66),\
(1325, 'Hato', 66),\
(1326, 'Jes\'fas Mar\'eda', 66),\
(1327, 'Jord\'e1n', 66),\
(1328, 'La Belleza', 66),\
(1329, 'La Paz', 66),\
(1330, 'Land\'e1zuri', 66),\
(1331, 'Lebrija', 66),\
(1332, 'Los Santos', 66),\
(1333, 'Macaravita', 66),\
(1334, 'M\'e1laga', 66),\
(1335, 'Matanza', 66),\
(1336, 'Mogotes', 66),\
(1337, 'Molagavita', 66),\
(1338, 'Ocamonte', 66),\
(1339, 'Oiba', 66),\
(1340, 'Onzaga', 66),\
(1341, 'Palmar', 66),\
(1342, 'Palmas del Socorro', 66),\
(1343, 'P\'e1ramo', 66),\
(1344, 'Piedecuesta', 66),\
(1345, 'Pinchote', 66),\
(1346, 'Puente Nacional', 66),\
(1347, 'Puerto Parra', 66),\
(1348, 'Puerto Wilches', 66),\
(1349, 'Rionegro', 66),\
(1350, 'Sabana de Torres', 66),\
(1351, 'San Andr\'e9s', 66),\
(1352, 'San Benito', 66),\
(1353, 'San Gil', 66),\
(1354, 'San Joaqu\'edn', 66),\
(1355, 'San Jos\'e9 de Miranda', 66),\
(1356, 'San Miguel', 66),\
(1357, 'San Vicente de Chucur\'ed', 66),\
(1358, 'Santa B\'e1rbara', 66),\
(1359, 'Santa Helena del Op\'f3n', 66),\
(1360, 'Simacota', 66),\
(1361, 'Suaita', 66),\
(1362, 'Sucre', 66),\
(1363, 'Surat\'e1', 66),\
(1364, 'Tona', 66),\
(1365, 'Valle de San Jos\'e9', 66),\
(1366, 'V\'e9lez', 66),\
(1367, 'Vetas', 66),\
(1368, 'Villanueva', 66),\
(1369, 'Zapatoca', 66),\
(1370, 'Buenavista', 67),\
(1371, 'Caimito', 67),\
(1372, 'Chal\'e1n', 67),\
(1373, 'Colos\'f3', 67),\
(1374, 'Corozal', 67),\
(1375, 'Cove\'f1as', 67),\
(1376, 'El Roble', 67),\
(1377, 'Galeras', 67),\
(1378, 'Guaranda', 67),\
(1379, 'La Uni\'f3n', 67),\
(1380, 'Los Palmitos', 67),\
(1381, 'Majagual', 67),\
(1382, 'Morroa', 67),\
(1383, 'Ovejas', 67),\
(1384, 'Sampu\'e9s', 67),\
(1385, 'San Antonio de Palmito', 67),\
(1386, 'San Benito Abad', 67),\
(1387, 'San Juan de Betulia', 67),\
(1388, 'San Marcos', 67),\
(1389, 'San Onofre', 67),\
(1390, 'San Pedro', 67),\
(1391, 'Sinc\'e9', 67),\
(1392, 'Sincelejo', 67),\
(1393, 'Sucre', 67),\
(1394, 'Tol\'fa', 67),\
(1395, 'Tol\'fa Viejo', 67),\
(1396, 'Alpujarra', 68),\
(1397, 'Alvarado', 68),\
(1398, 'Ambalema', 68),\
(1399, 'Anzo\'e1tegui', 68),\
(1400, 'Armero', 68),\
(1401, 'Ataco', 68),\
(1402, 'Cajamarca', 68),\
(1403, 'Carmen de Apical\'e1', 68),\
(1404, 'Casabianca', 68),\
(1405, 'Chaparral', 68),\
(1406, 'Coello', 68),\
(1407, 'Coyaima', 68),\
(1408, 'Cunday', 68),\
(1409, 'Dolores', 68),\
(1410, 'El Espinal', 68),\
(1411, 'Fal\'e1n', 68),\
(1412, 'Flandes', 68),\
(1413, 'Fresno', 68),\
(1414, 'Guamo', 68),\
(1415, 'Herveo', 68),\
(1416, 'Honda', 68),\
(1417, 'Ibagu\'e9', 68),\
(1418, 'Icononzo', 68),\
(1419, 'L\'e9rida', 68),\
(1420, 'L\'edbano', 68),\
(1421, 'Mariquita', 68),\
(1422, 'Melgar', 68),\
(1423, 'Murillo', 68),\
(1424, 'Natagaima', 68),\
(1425, 'Ortega', 68),\
(1426, 'Palocabildo', 68),\
(1427, 'Piedras', 68),\
(1428, 'Planadas', 68),\
(1429, 'Prado', 68),\
(1430, 'Purificaci\'f3n', 68),\
(1431, 'Rioblanco', 68),\
(1432, 'Roncesvalles', 68),\
(1433, 'Rovira', 68),\
(1434, 'Salda\'f1a', 68),\
(1435, 'San Antonio', 68),\
(1436, 'San Luis', 68),\
(1437, 'Santa Isabel', 68),\
(1438, 'Su\'e1rez', 68),\
(1439, 'Valle de San Juan', 68),\
(1440, 'Venadillo', 68),\
(1441, 'Villahermosa', 68),\
(1442, 'Villarrica', 68),\
(1443, 'Alcal\'e1', 69),\
(1444, 'Andaluc\'eda', 69),\
(1445, 'Ansermanuevo', 69),\
(1446, 'Argelia', 69),\
(1447, 'Bol\'edvar', 69),\
(1448, 'Buenaventura', 69),\
(1449, 'Buga', 69),\
(1450, 'Bugalagrande', 69),\
(1451, 'Caicedonia', 69),\
(1452, 'Cali', 69),\
(1453, 'Calima', 69),\
(1454, 'Candelaria', 69),\
(1455, 'Cartago', 69),\
(1456, 'Dagua', 69),\
(1457, 'El \'c1guila', 69),\
(1458, 'El Cairo', 69),\
(1459, 'El Cerrito', 69),\
(1460, 'El Dovio', 69),\
(1461, 'Florida', 69),\
(1462, 'Ginebra', 69),\
(1463, 'Guacar\'ed', 69),\
(1464, 'Jamund\'ed', 69),\
(1465, 'La Cumbre', 69),\
(1466, 'La Uni\'f3n', 69),\
(1467, 'La Victoria', 69),\
(1468, 'Obando', 69),\
(1469, 'Palmira', 69),\
(1470, 'Pradera', 69),\
(1471, 'Restrepo', 69),\
(1472, 'Riofr\'edo', 69),\
(1473, 'Roldanillo', 69),\
(1474, 'San Pedro', 69),\
(1475, 'Sevilla', 69),\
(1476, 'Toro', 69),\
(1477, 'Trujillo', 69),\
(1478, 'Tulu\'e1', 69),\
(1479, 'Ulloa', 69),\
(1480, 'Versalles', 69),\
(1481, 'Vijes', 69),\
(1482, 'Yotoco', 69),\
(1483, 'Yumbo', 69),\
(1484, 'Zarzal', 69),\
(1485, 'Carur\'fa', 70),\
(1486, 'Mit\'fa', 70),\
(1487, 'Taraira', 70),\
(1488, 'Cumaribo', 71),\
(1489, 'La Primavera', 71),\
(1490, 'Puerto Carre\'f1o', 71),\
(1491, 'Santa Rosal\'eda', 71),\
(1492, 'Aguascalientes', 72),\
(1493, 'Asientos', 72),\
(1494, 'Calvillo', 72),\
(1495, 'Cosio', 72),\
(1496, 'Jesus Maria', 72),\
(1497, 'Pabellon de Arteaga', 72),\
(1498, 'Rincon de Romos', 72),\
(1499, 'San Jose de Gracia', 72),\
(1500, 'Tepezala', 72),\
(1501, 'San Francisco de los Romo', 72),\
(1502, 'El Llano', 72),\
(1503, 'Ensenada', 73),\
(1504, 'Mexicali', 73),\
(1505, 'Tecate', 73),\
(1506, 'Tijuana', 73),\
(1507, 'Playas de Rosarito', 73),\
(1508, 'La Paz', 74),\
(1509, 'Los Cabos', 74),\
(1510, 'Loreto', 74),\
(1511, 'Mulege', 74),\
(1512, 'Comondu', 74),\
(1513, 'Calkini', 75),\
(1514, 'Palizada', 75),\
(1515, 'Campeche', 75),\
(1516, 'Tenabo', 75),\
(1517, 'Carmen', 75),\
(1518, 'Escarcega', 75),\
(1519, 'Champoton', 75),\
(1520, 'Calakmul', 75),\
(1521, 'Hecelchakan', 75),\
(1522, 'Candelaria', 75),\
(1523, 'Hopelchen', 75),\
(1524, 'Acacoyagua', 76),\
(1525, 'Osumacinta', 76),\
(1526, 'Acala', 76),\
(1527, 'Oxchuc', 76),\
(1528, 'Acapetahua', 76),\
(1529, 'Palenque', 76),\
(1530, 'Altamirano', 76),\
(1531, 'Pantelho', 76),\
(1532, 'Amatan', 76),\
(1533, 'Pantepec', 76),\
(1534, 'Amatenango de la Frontera', 76),\
(1535, 'Pichucalco', 76),\
(1536, 'Amatenango del Valle', 76),\
(1537, 'Pijijiapan', 76),\
(1538, '\'c1ngel Albino Corzo', 76),\
(1539, 'El Porvenir', 76),\
(1540, 'Arriaga', 76),\
(1541, 'Villa Comaltitlan', 76),\
(1542, 'Bejucal de Ocampo', 76),\
(1543, 'Pueblo Nuevo Solistahuacan', 76),\
(1544, 'Bella Vista', 76),\
(1545, 'Rayon', 76),\
(1546, 'Berriozabal', 76),\
(1547, 'Reforma', 76),\
(1548, 'Bochil', 76),\
(1549, 'Las Rosas', 76),\
(1550, 'El Bosque', 76),\
(1551, 'Sabanilla', 76),\
(1552, 'Cacahoatan', 76),\
(1553, 'Salto de Agua', 76),\
(1554, 'Catazaja', 76),\
(1555, 'San Cristobal de las Casas', 76),\
(1556, 'Cintalapa', 76),\
(1557, 'San Fernando', 76),\
(1558, 'Coapilla', 76),\
(1559, 'Siltepec', 76),\
(1560, 'Comitan de Dominguez', 76),\
(1561, 'Simojovel', 76),\
(1562, 'La Concordia', 76),\
(1563, 'Sitala', 76),\
(1564, 'Copainala', 76),\
(1565, 'Socoltenango', 76),\
(1566, 'Chalchihuitan', 76),\
(1567, 'Solosuchiapa', 76),\
(1568, 'Chamula', 76),\
(1569, 'Soyalo', 76),\
(1570, 'Chanal', 76),\
(1571, 'Suchiapa', 76),\
(1572, 'Chapultenango', 76),\
(1573, 'Suchiate', 76),\
(1574, 'Chenalho', 76),\
(1575, 'Sunuapa', 76),\
(1576, 'Chiapa de Corzo', 76),\
(1577, 'Tapachula', 76),\
(1578, 'Chiapilla', 76),\
(1579, 'Tapalapa', 76),\
(1580, 'Chicoasen', 76),\
(1581, 'Tapilula', 76),\
(1582, 'Chicomuselo', 76),\
(1583, 'Tecpatan', 76),\
(1584, 'Chilon', 76),\
(1585, 'Tenejapa', 76),\
(1586, 'Escuintla', 76),\
(1587, 'Teopisca', 76),\
(1588, 'Francisco Leon', 76),\
(1589, 'Frontera Comalapa', 76),\
(1590, 'Tila', 76),\
(1591, 'Frontera Hidalgo', 76),\
(1592, 'Tonala', 76),\
(1593, 'La Grandeza', 76),\
(1594, 'Totolapa', 76),\
(1595, 'Huehuetan', 76),\
(1596, 'La Trinitaria', 76),\
(1597, 'Huixtan', 76),\
(1598, 'Tumbala', 76),\
(1599, 'Huitiupan', 76),\
(1600, 'Tuxtla Gutierrez', 76),\
(1601, 'Huixtla', 76),\
(1602, 'Tuxtla Chico', 76),\
(1603, 'La Independencia', 76),\
(1604, 'Tuzantan', 76),\
(1605, 'Ixhuatan', 76),\
(1606, 'Tzimol', 76),\
(1607, 'Ixtacomitan', 76),\
(1608, 'Union Juarez', 76),\
(1609, 'Ixtapa', 76),\
(1610, 'Venustiano Carranza', 76),\
(1611, 'Ixtapangajoya', 76),\
(1612, 'Villa Corzo', 76),\
(1613, 'Jiquipilas', 76),\
(1614, 'Villaflores', 76),\
(1615, 'Jitotol', 76),\
(1616, 'Yajalon', 76),\
(1617, 'Juarez', 76),\
(1618, 'San Lucas', 76),\
(1619, 'Larrainzar', 76),\
(1620, 'Zinacantan', 76),\
(1621, 'La Libertad', 76),\
(1622, 'San Juan Cancuc', 76),\
(1623, 'Mapastepec', 76),\
(1624, 'Alaama', 76),\
(1625, 'Las Margaritas', 76),\
(1626, 'Benemerito de las Americas', 76),\
(1627, 'Mazapa de Madero', 76),\
(1628, 'Maravilla Tenejapa', 76),\
(1629, 'Mazatan', 76),\
(1630, 'Marques de Comillas', 76),\
(1631, 'Metapa', 76),\
(1632, 'Montecristo de Guerrero', 76),\
(1633, 'Mitontic', 76),\
(1634, 'San Andres Duraznal', 76),\
(1635, 'Motozintla', 76),\
(1636, 'Santiago el Pinar', 76),\
(1637, 'Nicolas Ruiz', 76),\
(1638, 'Belisario Dominguez', 76),\
(1639, 'Ocosingo', 76),\
(1640, 'Emiliano Zapata', 76),\
(1641, 'Ocotepec', 76),\
(1642, 'El Parral', 76),\
(1643, 'Ocozocoautla de Espinosa', 76),\
(1644, 'Mezcalapa', 76),\
(1645, 'Ahumada', 77),\
(1646, 'Gomez Farias', 77),\
(1647, 'Namiquipa', 77),\
(1648, 'Alaama', 77),\
(1649, 'Gran Morelos', 77),\
(1650, 'Nonoava', 77),\
(1651, 'Allende', 77),\
(1652, 'Guachochi', 77),\
(1653, 'Nvo. Casas Grandes', 77),\
(1654, 'Aquiles Serdan', 77),\
(1655, 'Guadalupe', 77),\
(1656, 'Ocampo', 77),\
(1657, 'Ascension', 77),\
(1658, 'Guadalupe y Calvo', 77),\
(1659, 'Ojinaga', 77),\
(1660, 'Bachiniva', 77),\
(1661, 'Guazapares', 77),\
(1662, 'Parral', 77),\
(1663, 'Balleza', 77),\
(1664, 'Guerrero', 77),\
(1665, 'Praxedis G. Guerrero', 77),\
(1666, 'Batopilas', 77),\
(1667, 'Huejotitan', 77),\
(1668, 'Riva Palacio', 77),\
(1669, 'Bocoyna', 77),\
(1670, 'Ignacio Zaragoza', 77),\
(1671, 'Rosales', 77),\
(1672, 'Buenaventura', 77),\
(1673, 'Janos', 77),\
(1674, 'Rosario', 77),\
(1675, 'Camargo', 77),\
(1676, 'Jimenez', 77),\
(1677, 'San Fco. de Borja', 77),\
(1678, 'Carichi', 77),\
(1679, ' Juarez', 77),\
(1680, 'San Fco. de Conchos', 77),\
(1681, 'Casas Grandes', 77),\
(1682, ' Julimes', 77),\
(1683, 'San Fco. del Oro', 77),\
(1684, 'Chihuahua', 77),\
(1685, 'La Cruz', 77),\
(1686, 'Santa Barbara', 77),\
(1687, 'Chinipas', 77),\
(1688, 'Lopez', 77),\
(1689, 'Santa Isabel', 77),\
(1690, 'Coronado', 77),\
(1691, 'Madera', 77),\
(1692, 'Satevo', 77),\
(1693, 'Coyame', 77),\
(1694, 'Maguarichi', 77),\
(1695, 'Saucillo', 77),\
(1696, 'Cuauhtemoc', 77),\
(1697, 'Manuel Benavides', 77),\
(1698, 'Temosachi', 77),\
(1699, 'Cusihuiriachi', 77),\
(1700, 'Matachi', 77),\
(1701, 'Urique', 77),\
(1702, 'Delicias', 77),\
(1703, 'Matamoros', 77),\
(1704, 'Uruachi', 77),\
(1705, 'Dr. Belisario Dominguez', 77),\
(1706, 'Meoqui', 77),\
(1707, 'Valle de Zaragoza', 77),\
(1708, 'El Tule', 77),\
(1709, 'Morelos', 77),\
(1710, 'Galeana', 77),\
(1711, 'Moris', 77),\
(1712, 'Abasolo', 78),\
(1713, 'Acu\'f1a', 78),\
(1714, 'Allende Allende', 78),\
(1715, 'Arteaga Arteaga', 78),\
(1716, 'Candela Candela', 78),\
(1717, 'Casta\'f1os', 78),\
(1718, 'Cuatro Cienegas', 78),\
(1719, 'Escobedo', 78),\
(1720, 'Francisco I.', 78),\
(1721, 'Frontera', 78),\
(1722, 'General Cepeda', 78),\
(1723, 'Guerrero', 78),\
(1724, 'Hidalgo', 78),\
(1725, 'Jimenez', 78),\
(1726, 'Juarez', 78),\
(1727, 'Lamadrid', 78),\
(1728, 'Matamoros', 78),\
(1729, 'Monclova', 78),\
(1730, 'Morelos', 78),\
(1731, 'Muzquiz Ciudad', 78),\
(1732, 'Nadadores', 78),\
(1733, 'Nava', 78),\
(1734, 'Ocampo', 78),\
(1735, 'Parras', 78),\
(1736, 'Piedras Negras', 78),\
(1737, 'Progreso', 78),\
(1738, 'Ramos Arizpe', 78),\
(1739, 'Sabinas', 78),\
(1740, 'Sacramento', 78),\
(1741, 'Saltillo', 78),\
(1742, 'San Buenaventura', 78),\
(1743, 'San Juan de Sabinas', 78),\
(1744, 'San Pedro', 78),\
(1745, 'Sierra Mojada', 78),\
(1746, 'Torreon', 78),\
(1747, 'Viesca', 78),\
(1748, 'Villa Union', 78),\
(1749, 'Zaragoza', 78),\
(1750, 'Armeria', 79),\
(1751, 'Colima', 79),\
(1752, 'Comala', 79),\
(1753, 'Coquimatlan', 79),\
(1754, 'Cuauhtemoc', 79),\
(1755, 'Ixtlahuacan', 79),\
(1756, 'Manzanillo', 79),\
(1757, 'Minatitlan', 79),\
(1758, 'Tecoman', 79),\
(1759, 'Villa de Alvarez', 79),\
(1760, 'Alvaro Obregon', 80),\
(1761, 'Azcapotzalco', 80),\
(1762, 'Benito Juarez', 80),\
(1763, 'Coyoacan', 80),\
(1764, 'Cuajimalpa de Morelos', 80),\
(1765, 'Cuauhtemoc', 80),\
(1766, 'Gustavo A. Madero', 80),\
(1767, 'Iztacalco', 80),\
(1768, 'Iztapalapa', 80),\
(1769, 'La Magdalena Contreras', 80),\
(1770, 'Miguel Hidalgo', 80),\
(1771, 'Milpa Alta', 80),\
(1772, 'Tlahuac', 80),\
(1773, 'Tlalpan', 80),\
(1774, 'Venustiano Carranza', 80),\
(1775, 'Xochimilco', 80),\
(1776, 'Canatlan', 81),\
(1777, 'Canelas', 81),\
(1778, 'Coneto de Comonfort', 81),\
(1779, 'Cuencame', 81),\
(1780, 'Durango', 81),\
(1781, 'El Oro', 81),\
(1782, 'Gomez Palacio', 81),\
(1783, 'Gral. Simon Boivar', 81),\
(1784, 'Guadalupe Victoria', 81),\
(1785, 'Guanacevi', 81),\
(1786, 'Hidalgo', 81),\
(1787, 'Inde', 81),\
(1788, 'Lerdo', 81),\
(1789, 'Mapimi', 81),\
(1790, 'Mezquital', 81),\
(1791, 'Nazas', 81),\
(1792, 'Nombre de Dios', 81),\
(1793, 'Nuevo Ideal', 81),\
(1794, 'Ocampo', 81),\
(1795, 'Otaez', 81),\
(1796, 'Panuco de Coronado', 81),\
(1797, 'Pe\'f1on Blanco', 81),\
(1798, 'Poanas', 81),\
(1799, 'Pueblo Nuevo', 81),\
(1800, 'Rodeo', 81),\
(1801, 'San Bernardo', 81),\
(1802, 'San Dimas', 81),\
(1803, 'San Juan de Guadalupe', 81),\
(1804, 'San Juan del Rio', 81),\
(1805, 'San Luis del Cordero', 81),\
(1806, 'San Pedro del Gallo', 81),\
(1807, 'Santa Clara', 81),\
(1808, 'Santiago Papasquiaro', 81),\
(1809, 'Suchil', 81),\
(1810, 'Tamazula', 81),\
(1811, 'Tepehuanes', 81),\
(1812, 'Tlahualilo', 81),\
(1813, 'Topia', 81),\
(1814, 'Vicente Guerrero', 81),\
(1815, 'Acambay', 82),\
(1816, 'Acolman', 82),\
(1817, 'Aculco', 82),\
(1818, 'Almoloya de Alquisiras', 82),\
(1819, 'Almoloya de Juarez', 82),\
(1820, 'Almoloya del Rio', 82),\
(1821, 'Amanalco', 82),\
(1822, 'Amatepec', 82),\
(1823, 'Amecameca', 82),\
(1824, 'Apaxco', 82),\
(1825, 'Atenco', 82),\
(1826, 'Atizapan', 82),\
(1827, 'Atizapan de Zaragoza', 82),\
(1828, 'Atlacomulco', 82),\
(1829, 'Atlautla', 82),\
(1830, 'Axapusco', 82),\
(1831, 'Ayapango', 82),\
(1832, 'Calimaya', 82),\
(1833, 'Capulhuac', 82),\
(1834, 'Chalco', 82),\
(1835, 'Chapa de Mota', 82),\
(1836, 'Chapultepec', 82),\
(1837, 'Chiautla', 82),\
(1838, 'Chicoloapan', 82),\
(1839, 'Chiconcuac', 82),\
(1840, 'Chimalhuacan', 82),\
(1841, 'Coacalco de Berriozabal', 82),\
(1842, 'Coatepec Harinas', 82),\
(1843, 'Cocotitlan', 82),\
(1844, 'Coyotepec', 82),\
(1845, 'Cuautitlan', 82),\
(1846, 'Cuautitlan Izcalli', 82),\
(1847, 'Donato Guerra', 82),\
(1848, 'Ecatepec de Morelos', 82),\
(1849, 'Ecatzingo', 82),\
(1850, 'El Oro', 82),\
(1851, 'Huehuetoca', 82),\
(1852, 'Hueypoxtla', 82),\
(1853, 'Huixquilucan', 82),\
(1854, 'Isidro Fabela', 82),\
(1855, 'Ixtapaluca', 82),\
(1856, 'Ixtapan de la Sal', 82),\
(1857, 'Ixtapan del Oro', 82),\
(1858, 'Ixtlahuaca', 82),\
(1859, 'Jaltenco', 82),\
(1860, 'Jilotepec', 82),\
(1861, 'Jilotzingo', 82),\
(1862, 'Jiquipilco', 82),\
(1863, 'Jocotitlan', 82),\
(1864, 'Joquicingo', 82),\
(1865, 'Juchitepec', 82),\
(1866, 'La Paz', 82),\
(1867, 'Lerma', 82),\
(1868, 'Luvianos', 82),\
(1869, 'Malinalco', 82),\
(1870, 'Melchor Ocampo', 82),\
(1871, 'Metepec', 82),\
(1872, 'Mexicaltzingo', 82),\
(1873, 'Morelos', 82),\
(1874, 'Naucalpan de Juarez', 82),\
(1875, 'Nextlalpan', 82),\
(1876, 'Nezahualcoyotl', 82),\
(1877, 'Nicolas Romero', 82),\
(1878, 'Nopaltepec', 82),\
(1879, 'Ocoyoacac', 82),\
(1880, 'Ocuilan', 82),\
(1881, 'Otumba', 82),\
(1882, 'Otzoloapan', 82),\
(1883, 'Otzolotepec', 82),\
(1884, 'Ozumba', 82),\
(1885, 'Papalotla', 82),\
(1886, 'Polotitlan', 82),\
(1887, 'Rayon', 82),\
(1888, 'San Antonio la Isla', 82),\
(1889, 'San Felipe del Progreso', 82),\
(1890, 'San Jose del Rincon', 82),\
(1891, 'San Martin de las Piramides', 82),\
(1892, 'San Mateo Atenco', 82),\
(1893, 'San Simon de Guerrero', 82),\
(1894, 'Santo Tomas', 82),\
(1895, 'Soyaniquilpan de Juarez', 82),\
(1896, 'Sultepec', 82),\
(1897, 'Tecamac', 82),\
(1898, 'Tejupilco', 82),\
(1899, 'Temamatla', 82),\
(1900, 'Temascalapa', 82),\
(1901, 'Temascalcingo', 82),\
(1902, 'Temascaltepec', 82),\
(1903, 'Temoaya', 82),\
(1904, 'Tenancingo', 82),\
(1905, 'Tenango del Aire', 82),\
(1906, 'Tenango del Valle', 82),\
(1907, 'Teoloyucan', 82),\
(1908, 'Teotihuacan', 82),\
(1909, 'Tepetlaoxtoc', 82),\
(1910, 'Tepetlixpa', 82),\
(1911, 'Tepotzotlan', 82),\
(1912, 'Tequixquiac', 82),\
(1913, 'Texcaltitlan', 82),\
(1914, 'Texcalyacac', 82),\
(1915, 'Texcoco', 82),\
(1916, 'Tezoyuca', 82),\
(1917, 'Tianguistenco', 82),\
(1918, 'Timilpan', 82),\
(1919, 'Tlalmanalco', 82),\
(1920, 'Tlalnepantla de Baz', 82),\
(1921, 'Tlatlaya', 82),\
(1922, 'Toluca', 82),\
(1923, 'Tonanitla', 82),\
(1924, 'Tonatico', 82),\
(1925, 'Tultepec', 82),\
(1926, 'Tultitlan', 82),\
(1927, 'Valle de Bravo', 82),\
(1928, 'Valle de Chalco Solidaridad', 82),\
(1929, 'Villa de Allende', 82),\
(1930, 'Villa del Carbon', 82),\
(1931, 'Villa Guerrero', 82),\
(1932, 'Villa Victoria', 82),\
(1933, 'Xalatlaco', 82),\
(1934, 'Xonacatlan', 82),\
(1935, 'Zacazonapan', 82),\
(1936, 'Zacualpan', 82),\
(1937, 'Zinacantepec', 82),\
(1938, 'Zumpahuacan', 82),\
(1939, 'Zumpango', 82),\
(1940, 'Abasolo', 83),\
(1941, 'Acambaro', 83),\
(1942, 'Allende', 83),\
(1943, 'Apaseo el Alto', 83),\
(1944, 'Apaseo el Grande', 83),\
(1945, 'Atarjea', 83),\
(1946, 'Celaya', 83),\
(1947, 'Comonfort', 83),\
(1948, 'Coroneo', 83),\
(1949, 'Cortazar', 83),\
(1950, 'Cueramaro', 83),\
(1951, 'Doctor Mora', 83),\
(1952, 'Dolores Hidalgo', 83),\
(1953, 'Guanajuato', 83),\
(1954, 'Huanimaro', 83),\
(1955, 'Irapuato', 83),\
(1956, 'Jaral del Progreso', 83),\
(1957, 'Jerecuaro', 83),\
(1958, 'Leon', 83),\
(1959, 'Manuel Doblado', 83),\
(1960, 'Moroleon', 83),\
(1961, 'Ocampo', 83),\
(1962, 'Penjamo', 83),\
(1963, 'Pueblo Nuevo', 83),\
(1964, 'Purisima del Rincon', 83),\
(1965, 'Romita', 83),\
(1966, 'Salamanca', 83),\
(1967, 'Salvatierra', 83),\
(1968, 'San Diego de la Union', 83),\
(1969, 'San Felipe', 83),\
(1970, 'San Francisco del Rincon', 83),\
(1971, 'San Jose Iturbide', 83),\
(1972, 'San Luis de la Paz', 83),\
(1973, 'Santa Catarina', 83),\
(1974, 'Santa Cruz de Juventino Rosas', 83),\
(1975, 'Santiago Maravatio', 83),\
(1976, 'Silao', 83),\
(1977, 'Tarandacuao', 83),\
(1978, 'Tarimoro', 83),\
(1979, 'Tierra Blanca', 83),\
(1980, 'Uriangato', 83),\
(1981, 'Valle de Santiago', 83),\
(1982, 'Victoria', 83),\
(1983, 'Villagran', 83),\
(1984, 'Xichu', 83),\
(1985, 'Yuriria', 83),\
(1986, 'Acapulco de Juarez', 84),\
(1987, 'Acatepec', 84),\
(1988, 'Ahuacuotzingo', 84),\
(1989, 'Ajuchitlan del Progreso', 84),\
(1990, 'Alcozauca de Guerrero', 84),\
(1991, 'Alpoyeca', 84),\
(1992, 'Apaxtla', 84),\
(1993, 'Arcelia', 84),\
(1994, 'Atenango del Rio', 84),\
(1995, 'Atlamajalcingo del Monte', 84),\
(1996, 'Atlixtac', 84),\
(1997, 'Atoyac de Alvarez', 84),\
(1998, 'Ayutla de los Libres', 84),\
(1999, 'Azoyu', 84),\
(2000, 'Benito Juarez', 84),\
(2001, 'Buenavista de Cuellar', 84),\
(2002, 'Chilapa de Alvarez', 84),\
(2003, 'Chilpancingo de los Bravo', 84),\
(2004, 'Coahuayutla de Jose Maria Izazaga', 84),\
(2005, 'Cochoapa el Grande', 84),\
(2006, 'Cocula', 84),\
(2007, 'Copala', 84),\
(2008, 'Copalillo', 84),\
(2009, 'Copanatoyac', 84),\
(2010, 'Coyuca de Benitez', 84),\
(2011, 'Coyuca de Catalan', 84),\
(2012, 'Cuajinicuilapa', 84),\
(2013, 'Cualac', 84),\
(2014, 'Cuautepec', 84),\
(2015, 'Cuetzala del Progreso', 84),\
(2016, 'Cutzamala de Pinzon', 84),\
(2017, 'Eduardo Neri', 84),\
(2018, 'Florencio Villarreal', 84),\
(2019, 'General Canuto A. Neri', 84),\
(2020, 'General Heliodoro Castillo', 84),\
(2021, 'Huamuxtitlan', 84),\
(2022, 'Huitzuco de los Figueroa', 84),\
(2023, 'Iguala de la Independencia', 84),\
(2024, 'Igualapa', 84),\
(2025, 'Ixcateopan de Cuauhtemoc', 84),\
(2026, 'Jose Azueta', 84),\
(2027, 'Jose Joaquin de Herrera', 84),\
(2028, 'Juan R. Escudero', 84),\
(2029, 'La Union de Isidoro Montes de Oca', 84),\
(2030, 'Leonardo Bravo', 84),\
(2031, 'Malinaltepec', 84),\
(2032, 'Marquelia', 84),\
(2033, 'Martir de Cuilapan', 84),\
(2034, 'Metlatonoc', 84),\
(2035, 'Mochitlan', 84),\
(2036, 'Olinala', 84),\
(2037, 'Ometepec', 84),\
(2038, 'Pedro Ascencio Alquisiras', 84),\
(2039, 'Petatlan', 84),\
(2040, 'Pilcaya', 84),\
(2041, 'Pungarabato', 84),\
(2042, 'Quechultenango', 84),\
(2043, 'San Luis Acatlan', 84),\
(2044, 'San Marcos', 84),\
(2045, 'San Miguel Totolapan', 84),\
(2046, 'Taxco de Alarcon', 84),\
(2047, 'Tecoanapa', 84),\
(2048, 'Tecpan de Galeana', 84),\
(2049, 'Teloloapan', 84),\
(2050, 'Tepecoacuilco de Trujano', 84),\
(2051, 'Tetipac', 84),\
(2052, 'Tixtla de Guerrero', 84),\
(2053, 'Tlacoachistlahuaca', 84),\
(2054, 'Tlacoapa', 84),\
(2055, 'Tlalchapa', 84),\
(2056, 'Tlalixtaquilla de Malaonado', 84),\
(2057, 'Tlapa de Comonfort', 84),\
(2058, 'Tlapehuala', 84),\
(2059, 'Xalpatlahuac', 84),\
(2060, 'Xochihuehuetlan', 84),\
(2061, 'Xochistlahuaca', 84),\
(2062, 'Zapotitlan Tablas', 84),\
(2063, 'Zirandaro', 84),\
(2064, 'Zitlala', 84),\
(2065, 'Acatlan', 85),\
(2066, 'Acaxochitlan', 85),\
(2067, 'Actopan', 85),\
(2068, 'Agua Blanca de Iturbide', 85),\
(2069, 'Ajacuba', 85),\
(2070, 'Alfajayucan', 85),\
(2071, 'Almoloya', 85),\
(2072, 'Apan', 85),\
(2073, 'Atitalaquia', 85),\
(2074, 'Atlapexco', 85),\
(2075, 'Atotonilco de Tula', 85),\
(2076, 'Atotonilco el Grande', 85),\
(2077, 'Calnali', 85),\
(2078, 'Cardonal', 85),\
(2079, 'Chapantongo', 85),\
(2080, 'Chapulhuacan', 85),\
(2081, 'Chilcuautla', 85),\
(2082, 'Cuautepec de Hinojosa', 85),\
(2083, 'El Arenal', 85),\
(2084, 'Eloxochitlan', 85),\
(2085, 'Emiliano Zapata', 85),\
(2086, 'Epazoyucan', 85),\
(2087, 'Francisco I. Madero', 85),\
(2088, 'Huasca de Ocampo', 85),\
(2089, 'Huautla', 85),\
(2090, 'Huazalingo', 85),\
(2091, 'Huehuetla', 85),\
(2092, 'Huejutla de Reyes', 85),\
(2093, 'Huichapan', 85),\
(2094, 'Ixmiquilpan', 85),\
(2095, 'Jacala de Ledezma', 85),\
(2096, 'Jaltocan', 85),\
(2097, 'Juarez Hidalgo', 85),\
(2098, 'La Mision', 85),\
(2099, 'Lolotla', 85),\
(2100, 'Metepec', 85),\
(2101, 'Metztitlan', 85),\
(2102, 'Mineral de la Reforma', 85),\
(2103, 'Mineral del Chico', 85),\
(2104, 'Mineral del Monte', 85),\
(2105, 'Mixquiahuala de Juarez', 85),\
(2106, 'Molango de Escamilla', 85),\
(2107, 'Nicolas Flores', 85),\
(2108, 'Nopala de Villagran', 85),\
(2109, 'Omitlan de Juarez', 85),\
(2110, 'Pachuca de Soto', 85),\
(2111, 'Pacula', 85),\
(2112, 'Pisaflores', 85),\
(2113, 'Progreso de Obregon', 85),\
(2114, 'San Agustin Metzquititlan', 85),\
(2115, 'San Agustin Tlaxiaca', 85),\
(2116, 'San Bartolo Tutotepec', 85),\
(2117, 'San Felipe Orizatlan', 85),\
(2118, 'San Salvador', 85),\
(2119, 'Santiago de Anaya', 85),\
(2120, 'Santiago Tulantepec de Lugo Guerre', 85),\
(2121, 'Singuilucan', 85),\
(2122, 'Tasquillo', 85),\
(2123, 'Tecozautla', 85),\
(2124, 'Tenango de Doria', 85),\
(2125, 'Tepeapulco', 85),\
(2126, 'Tepehuacan de Guerrero', 85),\
(2127, 'Tepeji del Rio de Ocampo', 85),\
(2128, 'Tepetitlan', 85),\
(2129, 'Tetepango', 85),\
(2130, 'Tezontepec de Alaama', 85),\
(2131, 'Tianguistengo', 85),\
(2132, 'Tizayuca', 85),\
(2133, 'Tlahuelilpan', 85),\
(2134, 'Tlahuiltepa', 85),\
(2135, 'Tlanalapa', 85),\
(2136, 'Tlanchinol', 85),\
(2137, 'Tlaxcoapan', 85),\
(2138, 'Tolcayuca', 85),\
(2139, 'Tula de Allende', 85);\
INSERT INTO `cities` (`id`, `name`, `region_id`) VALUES\
(2140, 'Tulancingo de Bravo', 85),\
(2141, 'Villa de Tezontepec', 85),\
(2142, 'Xochiatipan', 85),\
(2143, 'Xochicoatlan', 85),\
(2144, 'Yahualica', 85),\
(2145, 'Zacualtipan de Angeles', 85),\
(2146, 'Zapotlan de Juarez', 85),\
(2147, 'Zempoala', 85),\
(2148, 'Zimapan', 85),\
(2149, 'Acatic', 86),\
(2150, 'Acatlan de Juarez', 86),\
(2151, 'Ahualulco de Mercado', 86),\
(2152, 'Amacueca', 86),\
(2153, 'Amatitan', 86),\
(2154, 'Ameca', 86),\
(2155, 'Arandas', 86),\
(2156, 'Atemajac de Brizuela', 86),\
(2157, 'Atengo', 86),\
(2158, 'Atenguillo', 86),\
(2159, 'Atotonilco el Alto', 86),\
(2160, 'Atoyac', 86),\
(2161, 'Autlan de Navarro', 86),\
(2162, 'Ayotlan', 86),\
(2163, 'Ayutla', 86),\
(2164, 'Bola\'f1os', 86),\
(2165, 'Cabo Corrientes', 86),\
(2166, 'Ca\'f1adas de Obregon', 86),\
(2167, 'Casimiro Castillo', 86),\
(2168, 'Chapala', 86),\
(2169, 'Chimaltitan', 86),\
(2170, 'Chiquilistlan', 86),\
(2171, 'Cihuatlan', 86),\
(2172, 'Cocula', 86),\
(2173, 'Colotlan', 86),\
(2174, 'Concepcion de Buenos Aires', 86),\
(2175, 'Cuautitlan de Garcia Barragan', 86),\
(2176, 'Cuautla', 86),\
(2177, 'Cuquio', 86),\
(2178, 'Degollado', 86),\
(2179, 'Ejutla', 86),\
(2180, 'EL Arenal', 86),\
(2181, 'El Grullo', 86),\
(2182, 'El Limon', 86),\
(2183, 'El Salto', 86),\
(2184, 'Encarnacion de Diaz', 86),\
(2185, 'Etzatlan', 86),\
(2186, 'Gomez Farias', 86),\
(2187, 'Guachinango', 86),\
(2188, 'Guadalajara', 86),\
(2189, 'Hostotipaquillo', 86),\
(2190, 'Huejucar', 86),\
(2191, 'Huejuquilla el Alto', 86),\
(2192, 'Ixtlahuacan de los Membrillos', 86),\
(2193, 'Ixtlahuacan del Rio', 86),\
(2194, 'Jalostotitlan', 86),\
(2195, 'Jamay', 86),\
(2196, 'Jesus Maria', 86),\
(2197, 'Jilotlan de los Dolores', 86),\
(2198, 'Jocotepec', 86),\
(2199, 'Juanacatlan', 86),\
(2200, 'Juchitlan', 86),\
(2201, 'La Barca', 86),\
(2202, 'La Huerta', 86),\
(2203, 'La Manzanilla de la Paz', 86),\
(2204, 'Lagos de Moreno', 86),\
(2205, 'Magdalena', 86),\
(2206, 'Mascota', 86),\
(2207, 'Mazamitla', 86),\
(2208, 'Mexticacan', 86),\
(2209, 'Mezquitic', 86),\
(2210, 'Mixtlan', 86),\
(2211, 'Ocotlan', 86),\
(2212, 'Ojuelos de Jalisco', 86),\
(2213, 'Pihuamo', 86),\
(2214, 'Poncitlan', 86),\
(2215, 'Puerto Vallarta', 86),\
(2216, 'Quitupan', 86),\
(2217, 'San Cristobal de la Barranca', 86),\
(2218, 'San Diego de Alejandria', 86),\
(2219, 'San Gabriel', 86),\
(2220, 'San Juan de los Lagos', 86),\
(2221, 'San Juanito de Escobedo', 86),\
(2222, 'San Julian', 86),\
(2223, 'San Marcos', 86),\
(2224, 'San Martin de Bola\'f1os', 86),\
(2225, 'San Martin Hidalgo', 86),\
(2226, 'San Miguel el Alto', 86),\
(2227, 'San Sebastian del Oeste', 86),\
(2228, 'Santa Maria de los angeles', 86),\
(2229, 'Santa Maria del Oro', 86),\
(2230, 'Sayula', 86),\
(2231, 'Tala', 86),\
(2232, 'Talpa de Allende', 86),\
(2233, 'Tamazula de Gordiano', 86),\
(2234, 'Tapalpa', 86),\
(2235, 'Tecalitlan', 86),\
(2236, 'Techaluta de Montenegro', 86),\
(2237, 'Tecolotlan', 86),\
(2238, 'Tenamaxtlan', 86),\
(2239, 'Teocaltiche', 86),\
(2240, 'Teocuitatlan de Corona', 86),\
(2241, 'Tepatitlan de Morelos', 86),\
(2242, 'Tequila', 86),\
(2243, 'Teuchitlan', 86),\
(2244, 'Tizapan el Alto', 86),\
(2245, 'Tlajomulco de Zu\'f1iga', 86),\
(2246, 'Tlaquepaque', 86),\
(2247, 'Toliman', 86),\
(2248, 'Tomatlan', 86),\
(2249, 'Tonala', 86),\
(2250, 'Tonaya', 86),\
(2251, 'Tonila', 86),\
(2252, 'Totatiche', 86),\
(2253, 'Tototlan', 86),\
(2254, 'Tuxcacuesco', 86),\
(2255, 'Tuxcueca', 86),\
(2256, 'Tuxpan', 86),\
(2257, 'Union de San Antonio', 86),\
(2258, 'Union de Tula', 86),\
(2259, 'Valle de Guadalupe', 86),\
(2260, 'Valle de Juarez', 86),\
(2261, 'Villa Corona', 86),\
(2262, 'Villa Guerrero', 86),\
(2263, 'Villa Hidalgo', 86),\
(2264, 'Villa Purificacion', 86),\
(2265, 'Yahualica de Gonzalez Gallo', 86),\
(2266, 'Zacoalco de Torres', 86),\
(2267, 'Zapopan', 86),\
(2268, 'Zapotiltic', 86),\
(2269, 'Zapotitlan de Vadillo', 86),\
(2270, 'Zapotlan del Rey', 86),\
(2271, 'Zapotlan el Grande', 86),\
(2272, 'Zapotlanejo', 86),\
(2273, 'Acuitzio', 87),\
(2274, 'Aguililla', 87),\
(2275, 'Alvaro Obregon', 87),\
(2276, 'Angamacutiro', 87),\
(2277, 'Angangueo', 87),\
(2278, 'Apatzingan', 87),\
(2279, 'Aporo', 87),\
(2280, 'Aquila', 87),\
(2281, 'Ario', 87),\
(2282, 'Arteaga', 87),\
(2283, 'Brise\'f1as', 87),\
(2284, 'Buenavista', 87),\
(2285, 'Caracuaro', 87),\
(2286, 'Charapan', 87),\
(2287, 'Charo', 87),\
(2288, 'Chavinda', 87),\
(2289, 'Cheran', 87),\
(2290, 'Chilchota', 87),\
(2291, 'Chinicuila', 87),\
(2292, 'Chucandiro', 87),\
(2293, 'Churintzio', 87),\
(2294, 'Churumuco', 87),\
(2295, 'Coahuayana', 87),\
(2296, 'Coalcoman de Vazquez Pallares', 87),\
(2297, 'Coeneo', 87),\
(2298, 'Cojumatlan de Regules', 87),\
(2299, 'Contepec', 87),\
(2300, 'Copandaro', 87),\
(2301, 'Cotija', 87),\
(2302, 'Cuitzeo', 87),\
(2303, 'Ecuandureo', 87),\
(2304, 'Epitacio Huerta', 87),\
(2305, 'Erongaricuaro', 87),\
(2306, 'Gabriel Zamora', 87),\
(2307, 'Hidalgo', 87),\
(2308, 'Huandacareo', 87),\
(2309, 'Huaniqueo', 87),\
(2310, 'Huetamo', 87),\
(2311, 'Huiramba', 87),\
(2312, 'Indaparapeo', 87),\
(2313, 'Irimbo', 87),\
(2314, 'Ixtlan', 87),\
(2315, 'Jacona', 87),\
(2316, 'Jimenez', 87),\
(2317, 'Jiquilpan', 87),\
(2318, 'Jose Sixto Verduzco', 87),\
(2319, 'Juarez', 87),\
(2320, 'Jungapeo', 87),\
(2321, 'La Huacana', 87),\
(2322, 'La Piedad', 87),\
(2323, 'Lagunillas', 87),\
(2324, 'Lazaro Cardenas', 87),\
(2325, 'Los Reyes', 87),\
(2326, 'Madero', 87),\
(2327, 'Maravatio', 87),\
(2328, 'Marcos Castellanos', 87),\
(2329, 'Morelia', 87),\
(2330, 'Morelos', 87),\
(2331, 'Mugica', 87),\
(2332, 'Nahuatzen', 87),\
(2333, 'Nocupetaro', 87),\
(2334, 'Nuevo Parangaricutiro', 87),\
(2335, 'Nuevo Urecho', 87),\
(2336, 'Numaran', 87),\
(2337, 'Ocampo', 87),\
(2338, 'Pajacuaran', 87),\
(2339, 'Panindicuaro', 87),\
(2340, 'Paracho', 87),\
(2341, 'Paracuaro', 87),\
(2342, 'Patzcuaro', 87),\
(2343, 'Penjamillo', 87),\
(2344, 'Periban', 87),\
(2345, 'Purepero', 87),\
(2346, 'Puruandiro', 87),\
(2347, 'Querendaro', 87),\
(2348, 'Quiroga', 87),\
(2349, 'Sahuayo', 87),\
(2350, 'Salvador Escalante', 87),\
(2351, 'San Lucas', 87),\
(2352, 'Santa Ana Maya', 87),\
(2353, 'Senguio', 87),\
(2354, 'Susupuato', 87),\
(2355, 'Tacambaro', 87),\
(2356, 'Tancitaro', 87),\
(2357, 'Tangamandapio', 87),\
(2358, 'Tangancicuaro', 87),\
(2359, 'Tanhuato', 87),\
(2360, 'Taretan', 87),\
(2361, 'Tarimbaro', 87),\
(2362, 'Tepalcatepec', 87),\
(2363, 'Tingaindin', 87),\
(2364, 'Tingambato', 87),\
(2365, 'Tiquicheo de Nicolas Romero', 87),\
(2366, 'Tlalpujahua', 87),\
(2367, 'Tlazazalca', 87),\
(2368, 'Tocumbo', 87),\
(2369, 'Tumbiscatio', 87),\
(2370, 'Turicato', 87),\
(2371, 'Tuxpan', 87),\
(2372, 'Tuzantla', 87),\
(2373, 'Tzintzuntzan', 87),\
(2374, 'Tzitzio', 87),\
(2375, 'Uruapan', 87),\
(2376, 'Venustiano Carranza', 87),\
(2377, 'Villamar', 87),\
(2378, 'Vista Hermosa', 87),\
(2379, 'Yurecuaro', 87),\
(2380, 'Zacapu', 87),\
(2381, 'Zamora', 87),\
(2382, 'Zinaparo', 87),\
(2383, 'Zinapecuaro', 87),\
(2384, 'Ziracuaretiro', 87),\
(2385, 'Zitacuaro', 87),\
(2386, 'Amacuzac', 88),\
(2387, 'Atlatlahucan', 88),\
(2388, 'Axochiapan', 88),\
(2389, 'Ayala', 88),\
(2390, 'Coatlan del Rio', 88),\
(2391, 'Cuautla', 88),\
(2392, 'Cuernavaca', 88),\
(2393, 'Emiliano Zapata', 88),\
(2394, 'Huitzilac', 88),\
(2395, 'Jantetelco', 88),\
(2396, 'Jiutepec', 88),\
(2397, 'Jojutla', 88),\
(2398, 'Jonacatepec', 88),\
(2399, 'Mazatepec', 88),\
(2400, 'Miacatlan', 88),\
(2401, 'Ocuituco', 88),\
(2402, 'Puente de Ixtla', 88),\
(2403, 'Temixco', 88),\
(2404, 'Temoac', 88),\
(2405, 'Tepalcingo', 88),\
(2406, 'Tepoztlan', 88),\
(2407, 'Tetecala', 88),\
(2408, 'Tetela del Volcan', 88),\
(2409, 'Tlalnepantla', 88),\
(2410, 'Tlaltizapan', 88),\
(2411, 'Tlaquiltenango', 88),\
(2412, 'Tlayacapan', 88),\
(2413, 'Totolapan', 88),\
(2414, 'Xochitepec', 88),\
(2415, 'Yautepec', 88),\
(2416, 'Yecapixtla', 88),\
(2417, 'Zacatepec de Hidalgo', 88),\
(2418, 'Zacualpan de Amilpas', 88),\
(2419, 'Acaponeta', 89),\
(2420, 'Ahuacatlan', 89),\
(2421, 'Amatlan de Ca\'f1as', 89),\
(2422, 'Bahia de Banderas', 89),\
(2423, 'Compostela', 89),\
(2424, 'Del Nayar', 89),\
(2425, 'Huajicori', 89),\
(2426, 'Ixtlan del Rio', 89),\
(2427, 'Jala', 89),\
(2428, 'La Yesca', 89),\
(2429, 'Rosamorada', 89),\
(2430, 'Ruiz', 89),\
(2431, 'San Blas', 89),\
(2432, 'San Pedro Lagunillas', 89),\
(2433, 'Santa Maria del Oro', 89),\
(2434, 'Santiago Ixcuintla', 89),\
(2435, 'Tecuala', 89),\
(2436, 'Tepic', 89),\
(2437, 'Tuxpan', 89),\
(2438, 'Xalisco', 89),\
(2439, 'Abasolo', 90),\
(2440, 'Agualeguas', 90),\
(2441, 'Allende', 90),\
(2442, 'Anahuac', 90),\
(2443, 'Apodaca', 90),\
(2444, 'Aramberri', 90),\
(2445, 'Bustamante', 90),\
(2446, 'Cadereyta Jimenez', 90),\
(2447, 'Carmen', 90),\
(2448, 'Cerralvo', 90),\
(2449, 'China', 90),\
(2450, 'Cienega de Flores', 90),\
(2451, 'Dr. Coss', 90),\
(2452, 'Dr. Arroyo', 90),\
(2453, 'Dr. Gonzalez', 90),\
(2454, 'Galeana', 90),\
(2455, 'Garcia', 90),\
(2456, 'Gral. Escobedo', 90),\
(2457, 'Gral. Teran', 90),\
(2458, 'Gral. Trevi\'f1o', 90),\
(2459, 'Gral. Zaragoza', 90),\
(2460, 'Gral. Zuazua', 90),\
(2461, 'Gral. Bravo', 90),\
(2462, 'Guadalupe', 90),\
(2463, 'Hidalgo', 90),\
(2464, 'Higueras', 90),\
(2465, 'Hualahuises', 90),\
(2466, 'Iturbide', 90),\
(2467, 'Juarez', 90),\
(2468, 'Lampazos de Naranjo', 90),\
(2469, 'Linares', 90),\
(2470, 'Los Alaamas', 90),\
(2471, 'Los Herreras', 90),\
(2472, 'Los Ramones', 90),\
(2473, 'Marin', 90),\
(2474, 'Melchor Ocampo', 90),\
(2475, 'Mier y Noriega', 90),\
(2476, 'Mina', 90),\
(2477, 'Montemorelos', 90),\
(2478, 'Monterrey', 90),\
(2479, 'Paras', 90),\
(2480, 'Pesqueria', 90),\
(2481, 'Rayones', 90),\
(2482, 'Sabinas Hidalgo', 90),\
(2483, 'Salinas Victoria', 90),\
(2484, 'San Nicolas de los Garza', 90),\
(2485, 'San Pedro Garza Garcia', 90),\
(2486, 'Santa Catarina', 90),\
(2487, 'Santiago', 90),\
(2488, 'Vallecillo', 90),\
(2489, 'Villalaama', 90),\
(2490, 'abejones', 91),\
(2491, 'acatlan de Perez Figuerod', 91),\
(2492, 'animas Trujdno', 91),\
(2493, 'asuncion Cacalotepec', 91),\
(2494, 'asuncion Cuyotepeji', 91),\
(2495, 'asuncion Ixtaltepec', 91),\
(2496, 'asuncion Nochixtlan', 91),\
(2497, 'asuncion Ocotlan', 91),\
(2498, 'asuncion Tlacolulita', 91),\
(2499, 'ayotzintepec', 91),\
(2500, 'Calihuala', 91),\
(2501, 'Candelaria Loxicha', 91),\
(2502, 'Capulalpam de Mendez', 91),\
(2503, 'Chahuites', 91),\
(2504, 'Chalcatongo de Hiaalgo', 91),\
(2505, 'Chiquihuitlan de Benito Juarez', 91),\
(2506, 'Cienega de Zimatlan', 91),\
(2507, 'Ciuaaa Ixtepec', 91),\
(2508, 'Coatecas altas', 91),\
(2509, 'Coicoyan de las Flores', 91),\
(2510, 'Concepcion Buenavista', 91),\
(2511, 'Concepcion Papalo', 91),\
(2512, 'Constancia del Rosario', 91),\
(2513, 'Cosolapa', 91),\
(2514, 'Cosoltepec', 91),\
(2515, 'Cuilapam de Guerrero', 91),\
(2516, 'Cuyamecalco Villa de Zaragoza', 91),\
(2517, 'El Barrio de la Soleaaa', 91),\
(2518, 'El Espinal', 91),\
(2519, 'Eloxochitlan de Flores Magon', 91),\
(2520, 'Fresnillo de Trujano', 91),\
(2521, 'Guadalupe de Ramirez', 91),\
(2522, 'Guadalupe Etla', 91),\
(2523, 'Guelatao de Juarez', 91),\
(2524, 'Guevea de Humboldt', 91),\
(2525, 'Heroica Ciudad de Ejutla de Crespo', 91),\
(2526, 'Heroica Ciudad de Huajuapan de Leo', 91),\
(2527, 'Heroica Ciudad de Tlaxiaco', 91),\
(2528, 'Huautepec', 91),\
(2529, 'Huautla de Jimenez', 91),\
(2530, 'Ixpantepec Nieves', 91),\
(2531, 'Ixtlan de Juarez', 91),\
(2532, 'Juchitan de Zaragoza', 91),\
(2533, 'la Compa\'f1id', 91),\
(2534, 'la Pe', 91),\
(2535, 'la Reforma', 91),\
(2536, 'la Trinidad Vista Hermosa', 91),\
(2537, 'Loma Bonita', 91),\
(2538, 'Magdalena apasco', 91),\
(2539, 'Magdalena Jaltepec', 91),\
(2540, 'Magdalena Mixtepec', 91),\
(2541, 'Magdalena Ocotlan', 91),\
(2542, 'Magdalena Pe\'f1asco', 91),\
(2543, 'Magdalena Teitipac', 91),\
(2544, 'Magdalena Tequisistlan', 91),\
(2545, 'Magdalena Tlacotepec', 91),\
(2546, 'Magdalena Yodocono de Porfirio Diaz', 91),\
(2547, 'Magdalena Zahudtlan', 91),\
(2548, 'Mariscala de Juarez', 91),\
(2549, 'Martires de Tacubaya', 91),\
(2550, 'Matias Romero avenda\'f1o', 91),\
(2551, 'Mazatlan Villa de Flores', 91),\
(2552, 'Mesones Hidalgo', 91),\
(2553, 'Miahuatlan de Porfirio Diaz', 91),\
(2554, 'Mixistlan de la Reforma', 91),\
(2555, 'Monjas', 91),\
(2556, 'Natividad', 91),\
(2557, 'Nazareno Etla', 91),\
(2558, 'Nejapa de Madero', 91),\
(2559, 'Nuevo Zoquidpam', 91),\
(2560, 'Oaxaca de Juarez', 91),\
(2561, 'Ocotlan de Morelos', 91),\
(2562, 'Pinotepa de Don Luis', 91),\
(2563, 'Pluma Hidalgo', 91),\
(2564, 'Putla Villa de Guerrero', 91),\
(2565, 'Reforma de Pineda', 91),\
(2566, 'Reyes Etla', 91),\
(2567, 'Rojas de Cuauhtemoc', 91),\
(2568, 'Salina Cruz', 91),\
(2569, 'San agustin amatengo', 91),\
(2570, 'San agustin dtendngo', 91),\
(2571, 'San agustin Chdyuco', 91),\
(2572, 'San agustin de las Juntds', 91),\
(2573, 'San agustin Etla', 91),\
(2574, 'San agustin Loxichd', 91),\
(2575, 'San agustin Tlacotepec', 91),\
(2576, 'San agustin Ydtdreni', 91),\
(2577, 'San andres Cdbecerd Nuevd', 91),\
(2578, 'San andres Dinicuiti', 91),\
(2579, 'San andres Hudxpdltepec', 91),\
(2580, 'San andres Hudydpdm', 91),\
(2581, 'San andres Ixtlahudcd', 91),\
(2582, 'San andres lagunds', 91),\
(2583, 'San andres Nuxi\'f1o', 91),\
(2584, 'San andres Pdxtlan', 91),\
(2585, 'San andres Sindxtla', 91),\
(2586, 'San andres Solagd', 91),\
(2587, 'San andres Teotilalpdm', 91),\
(2588, 'San andres Tepetlapd', 91),\
(2589, 'San andres Yda', 91),\
(2590, 'San andres Zdbdche', 91),\
(2591, 'San andres Zdutla', 91),\
(2592, 'San antonino Cdstillo Velasco', 91),\
(2593, 'San antonino el dlto', 91),\
(2594, 'San antonino Monte Verde', 91),\
(2595, 'San antonio dcutla', 91),\
(2596, 'San antonio de la Cdl', 91),\
(2597, 'San antonio Huitepec', 91),\
(2598, 'San antonio Ndndhudtipdm', 91),\
(2599, 'San antonio Sinicdhud', 91),\
(2600, 'San antonio Tepetlapd', 91),\
(2601, 'San Baltazar Chichicapdm', 91),\
(2602, 'San Baltazar Loxichd', 91),\
(2603, 'San Baltazar Ydtzdchi el Bdjo', 91),\
(2604, 'San Bartolo Coyotepec', 91),\
(2605, 'San Bartolo Soydltepec', 91),\
(2606, 'San Bartolo Ydutepec', 91),\
(2607, 'San Bartolome dydutla', 91),\
(2608, 'San Bartolome Loxichd', 91),\
(2609, 'San Bartolome Quidland', 91),\
(2610, 'San Bartolome Yucud\'f1e', 91),\
(2611, 'San Bartolome Zoogocho', 91),\
(2612, 'San Berndrdo Mixtepec', 91),\
(2613, 'San Blas dtempd', 91),\
(2614, 'San Cdrlos Ydutepec', 91),\
(2615, 'San Cristobdl dmdtlan', 91),\
(2616, 'San Cristobdl dmoltepec', 91),\
(2617, 'San Cristobdl lachiriodg', 91),\
(2618, 'San Cristobdl Suchixtlahudcd', 91),\
(2619, 'San Dionisio del Mdr', 91),\
(2620, 'San Dionisio Ocotepec', 91),\
(2621, 'San Dionisio Ocotlan', 91),\
(2622, 'San Estebdn dtdtlahucd', 91),\
(2623, 'San Felipe Jdlapd de Didz', 91),\
(2624, 'San Felipe Tejdlapdm', 91),\
(2625, 'San Felipe Usila', 91),\
(2626, 'San Francisco Cahuacua', 91),\
(2627, 'San Francisco Cajonos', 91),\
(2628, 'San Francisco Chapulapa', 91),\
(2629, 'San Francisco Chindua', 91),\
(2630, 'San Francisco del Mar', 91),\
(2631, 'San Francisco Huehuetlan', 91),\
(2632, 'San Francisco Ixhuatan', 91),\
(2633, 'San Francisco Jaltepetongo', 91),\
(2634, 'San Francisco Lachigolo', 91),\
(2635, 'San Francisco Logueche', 91),\
(2636, 'San Francisco Nuxa\'f1o', 91),\
(2637, 'San Francisco Ozolotepec', 91),\
(2638, 'San Francisco Sola', 91),\
(2639, 'San Francisco Telixtlahuaca', 91),\
(2640, 'San Francisco Teopan', 91),\
(2641, 'San Francisco Tlapancingo', 91),\
(2642, 'San Gabriel Mixtepec', 91),\
(2643, 'San Ilaefonso Amatlan', 91),\
(2644, 'San Ilaefonso Sola', 91),\
(2645, 'San Ilaefonso Villa Alta', 91),\
(2646, 'San Jacinto Amilpas', 91),\
(2647, 'San Jacinto Tlacotepec', 91),\
(2648, 'San Jeronimo Coatlan', 91),\
(2649, 'San Jeronimo Silacayoapilla', 91),\
(2650, 'San Jeronimo Sosola', 91),\
(2651, 'San Jeronimo Taviche', 91),\
(2652, 'San Jeronimo Tecoatl', 91),\
(2653, 'San Jeronimo Tlacochahuaya', 91),\
(2654, 'San Jorge Nuchita', 91),\
(2655, 'San Jose Ayuquila', 91),\
(2656, 'San Jose Chiltepec', 91),\
(2657, 'San Jose del Pe\'f1asco', 91),\
(2658, 'San Jose del Progreso', 91),\
(2659, 'San Jose Estancia Grande', 91),\
(2660, 'San Jose Independencia', 91),\
(2661, 'San Jose Lachiguiri', 91),\
(2662, 'San Jose Tenango', 91),\
(2663, 'San Juan umi', 91),\
(2664, 'San Juan Achiutla', 91),\
(2665, 'San Juan Atepec', 91),\
(2666, 'San Juan Bautista Atatlahuca', 91),\
(2667, 'San Juan Bautista Coixtlahuaca', 91),\
(2668, 'San Juan Bautista Cuicatlan', 91),\
(2669, 'San Juan Bautista Guelache', 91),\
(2670, 'San Juan Bautista Jayacatlan', 91),\
(2671, 'San Juan Bautista Lo de Soto', 91),\
(2672, 'San Juan Bautista Suchitepec', 91),\
(2673, 'San Juan Bautista Tlachichilco', 91),\
(2674, 'San Juan Bautista Tlacoatzintepec', 91),\
(2675, 'San Juan Bautista Tuxtepec', 91),\
(2676, 'San Juan Bautista Valle Nacional', 91),\
(2677, 'San Juan Cacahuatepec', 91),\
(2678, 'San Juan Chicomezuchil', 91),\
(2679, 'San Juan Chilateca', 91),\
(2680, 'San Juan Cieneguilla', 91),\
(2681, 'San Juan Coatzospam', 91),\
(2682, 'San Juan Colorado', 91),\
(2683, 'San Juan Comaltepec', 91),\
(2684, 'San Juan Cotzocon', 91),\
(2685, 'San Juan de los Cues', 91),\
(2686, 'San Juan del Estado', 91),\
(2687, 'San Juan del Rio', 91),\
(2688, 'San Juan Diuxi', 91),\
(2689, 'San Juan Evangelista Analco', 91),\
(2690, 'San Juan Guelavia', 91),\
(2691, 'San Juan Guichicovi', 91),\
(2692, 'San Juan Ihualtepec', 91),\
(2693, 'San Juan Juquila Mixes', 91),\
(2694, 'San Juan Juquila Vijanos', 91),\
(2695, 'San Juan Lachao', 91),\
(2696, 'San Juan Lachigalla', 91),\
(2697, 'San Juan Lajarcia', 91),\
(2698, 'San Juan Lalana', 91),\
(2699, 'San Juan Mazatlan', 91),\
(2700, 'San Juan Mixtepec', 91),\
(2701, 'San Juan Mixtepec', 91),\
(2702, 'San Juan Ozolotepec', 91),\
(2703, 'San Juan Petlapa', 91),\
(2704, 'San Juan Quiahije', 91),\
(2705, 'San Juan Quiotepec', 91),\
(2706, 'San Juan Sayultepec', 91),\
(2707, 'San Juan Tabaa', 91),\
(2708, 'San Juan Tamazola', 91),\
(2709, 'San Juan Teita', 91),\
(2710, 'San Juan Teitipac', 91),\
(2711, 'San Juan Tepeuxila', 91),\
(2712, 'San Juan Teposcolula', 91),\
(2713, 'San Juan Yaee', 91),\
(2714, 'San Juan Yatzona', 91),\
(2715, 'San Juan Yucuita', 91),\
(2716, 'San Lorenzo', 91),\
(2717, 'San Lorenzo Albarradas', 91),\
(2718, 'San Lorenzo Cacaotepec', 91),\
(2719, 'San Lorenzo Cuaunecuiltitla', 91),\
(2720, 'San Lorenzo Texmelucan', 91),\
(2721, 'San Lorenzo Victoria', 91),\
(2722, 'San Lucas Camotlan', 91),\
(2723, 'San Lucas Ojitlan', 91),\
(2724, 'San Lucas Quiavini', 91),\
(2725, 'San Lucas Zoquiapam', 91),\
(2726, 'San Luis Amatlan', 91),\
(2727, 'San Marcial Ozolotepec', 91),\
(2728, 'San Marcos Arteaga', 91),\
(2729, 'San Martin de los Cansecos', 91),\
(2730, 'San Martin Huamelulpam', 91),\
(2731, 'San Martin Itunyoso', 91),\
(2732, 'San Martin Lachila', 91),\
(2733, 'San Martin Peras', 91),\
(2734, 'San Martin Tilcajete', 91),\
(2735, 'San Martin Toxpalan', 91),\
(2736, 'San Martin Zacatepec', 91),\
(2737, 'San Mateo Cajonos', 91),\
(2738, 'San Mateo del Mar', 91),\
(2739, 'San Mateo Etlatongo', 91),\
(2740, 'San Mateo Nejapam', 91),\
(2741, 'San Mateo Pe\'f1asco', 91),\
(2742, 'San Mateo Pi\'f1as', 91),\
(2743, 'San Mateo Rio Hondo', 91),\
(2744, 'San Mateo Sindihui', 91),\
(2745, 'San Mateo Tlapiltepec', 91),\
(2746, 'San Mateo Yoloxochitlan', 91),\
(2747, 'San Melchor Betaza', 91),\
(2748, 'San Miguel Achiutla', 91),\
(2749, 'San Miguel Ahuehuetitlan', 91),\
(2750, 'San Miguel Aloapam', 91),\
(2751, 'San Miguel Amatitlan', 91),\
(2752, 'San Miguel Amatlan', 91),\
(2753, 'San Miguel Chicahua', 91),\
(2754, 'San Miguel Chimalapa', 91),\
(2755, 'San Miguel Coatlan', 91),\
(2756, 'San Miguel del Puerto', 91),\
(2757, 'San Miguel del Rio', 91),\
(2758, 'San Miguel Ejutla', 91),\
(2759, 'San Miguel el Grande', 91),\
(2760, 'San Miguel Huautla', 91),\
(2761, 'San Miguel Mixtepec', 91),\
(2762, 'San Miguel Panixtlahuaca', 91),\
(2763, 'San Miguel Peras', 91),\
(2764, 'San Miguel Piedras', 91),\
(2765, 'San Miguel Quetzaltepec', 91),\
(2766, 'San Miguel Santa Flor', 91),\
(2767, 'San Miguel Soyaltepec', 91),\
(2768, 'San Miguel Suchixtepec', 91),\
(2769, 'San Miguel Tecomatlan', 91),\
(2770, 'San Miguel Tenango', 91),\
(2771, 'San Miguel Tequixtepec', 91),\
(2772, 'San Miguel Tilquiapam', 91),\
(2773, 'San Miguel Tlacamama', 91),\
(2774, 'San Miguel Tlacotepec', 91),\
(2775, 'San Miguel Tulancingo', 91),\
(2776, 'San Miguel Yotao', 91),\
(2777, 'San Nicolas', 91),\
(2778, 'San Nicolas Hidalgo', 91),\
(2779, 'San Pablo Coatlan', 91),\
(2780, 'San Pablo Cuatro Venados', 91),\
(2781, 'San Pablo Etla', 91),\
(2782, 'San Pablo Huitzo', 91),\
(2783, 'San Pablo Huixtepec', 91),\
(2784, 'San Pablo Macuiltianguis', 91),\
(2785, 'San Pablo Tijaltepec', 91),\
(2786, 'San Pablo Villa de Mitla', 91),\
(2787, 'San Pablo Yaganiza', 91),\
(2788, 'San Pedro Amuzgos', 91),\
(2789, 'San Pedro Apostol', 91),\
(2790, 'San Pedro Atoyac', 91),\
(2791, 'San Pedro Cajonos', 91),\
(2792, 'San Pedro Comitancillo', 91),\
(2793, 'San Pedro Coxcaltepec Cantaros', 91),\
(2794, 'San Pedro el Alto', 91),\
(2795, 'San Pedro Huamelula', 91),\
(2796, 'San Pedro Huilotepec', 91),\
(2797, 'San Pedro Ixcatlan', 91),\
(2798, 'San Pedro Ixtlahuaca', 91),\
(2799, 'San Pedro Jaltepetongo', 91),\
(2800, 'San Pedro Jicayan', 91),\
(2801, 'San Pedro Jocotipac', 91),\
(2802, 'San Pedro Juchatengo', 91),\
(2803, 'San Pedro Martir', 91),\
(2804, 'San Pedro Martir Quiechapa', 91),\
(2805, 'San Pedro Martir Yucuxaco', 91),\
(2806, 'San Pedro Mixtepec', 91),\
(2807, 'San Pedro Mixtepec', 91),\
(2808, 'San Pedro Molinos', 91),\
(2809, 'San Pedro Nopala', 91),\
(2810, 'San Pedro Ocopetatillo', 91),\
(2811, 'San Pedro Ocotepec', 91),\
(2812, 'San Pedro Pochutla', 91),\
(2813, 'San Pedro Quiatoni', 91),\
(2814, 'San Pedro Sochiapam', 91),\
(2815, 'San Pedro Tapanatepec', 91),\
(2816, 'San Pedro Taviche', 91),\
(2817, 'San Pedro Teozacoalco', 91),\
(2818, 'San Pedro Teutila', 91),\
(2819, 'San Pedro Tidaa', 91),\
(2820, 'San Pedro Topiltepec', 91),\
(2821, 'San Pedro Totolapa', 91),\
(2822, 'San Pedro y San Pablo Ayutla', 91),\
(2823, 'San Pedro y San Pablo Teposcolula', 91),\
(2824, 'San Pedro y San Pablo Tequixtepec', 91),\
(2825, 'San Pedro Yaneri', 91),\
(2826, 'San Pedro Yolox', 91),\
(2827, 'San Pedro Yucunama', 91),\
(2828, 'San Raymundo Jalpan', 91),\
(2829, 'San Sebastian Abasolo', 91),\
(2830, 'San Sebastian Coatlan', 91),\
(2831, 'San Sebastian Ixcapa', 91),\
(2832, 'San Sebastian Nicananduta', 91),\
(2833, 'San Sebastian Rio Hondo', 91),\
(2834, 'San Sebastian Tecomaxtlahuaca', 91),\
(2835, 'San Sebastian Teitipac', 91),\
(2836, 'San Sebastian Tutla', 91),\
(2837, 'San Simon Almolongas', 91),\
(2838, 'San Simon Zahuatlan', 91),\
(2839, 'San Vicente Coatlan', 91),\
(2840, 'San Vicente Lachixio', 91),\
(2841, 'San Vicente Nu\'f1u', 91),\
(2842, 'Santa Ana', 91),\
(2843, 'Santa Ana Ateixtlahuaca', 91),\
(2844, 'Santa Ana Cuauhtemoc', 91),\
(2845, 'Santa Ana del Valle', 91),\
(2846, 'Santa Ana Tavela', 91),\
(2847, 'Santa Ana Tlapacoyan', 91),\
(2848, 'Santa Ana Yareni', 91),\
(2849, 'Santa Ana Zegache', 91),\
(2850, 'Santa Catalina Quieri', 91),\
(2851, 'Santa Catarina Cuixtla', 91),\
(2852, 'Santa Catarina Ixtepeji', 91),\
(2853, 'Santa Catarina Juquila', 91),\
(2854, 'Santa Catarina Lachatao', 91),\
(2855, 'Santa Catarina Loxicha', 91),\
(2856, 'Santa Catarina Mechoacan', 91),\
(2857, 'Santa Catarina Minas', 91),\
(2858, 'Santa Catarina Quiane', 91),\
(2859, 'Santa Catarina Quioquitani', 91),\
(2860, 'Santa Catarina Tayata', 91),\
(2861, 'Santa Catarina Ticua', 91),\
(2862, 'Santa Catarina Yosonotu', 91),\
(2863, 'Santa Catarina Zapoquila', 91),\
(2864, 'Santa Cruz Acatepec', 91),\
(2865, 'Santa Cruz Amilpas', 91),\
(2866, 'Santa Cruz de Bravo', 91),\
(2867, 'Santa Cruz Itundujia', 91),\
(2868, 'Santa Cruz Mixtepec', 91),\
(2869, 'Santa Cruz Nundaco', 91),\
(2870, 'Santa Cruz Papalutla', 91),\
(2871, 'Santa Cruz Tacache de Mina', 91),\
(2872, 'Santa Cruz Tacahua', 91),\
(2873, 'Santa Cruz Tayata', 91),\
(2874, 'Santa Cruz Xitla', 91),\
(2875, 'Santa Cruz Xoxocotlan', 91),\
(2876, 'Santa Cruz Zenzontepec', 91),\
(2877, 'Santa Gertrudis', 91),\
(2878, 'Santa Ines de Zaragoza', 91),\
(2879, 'Santa Ines del Monte', 91),\
(2880, 'Santa Ines Yatzeche', 91),\
(2881, 'Santa Lucia del Camino', 91),\
(2882, 'Santa Lucia Miahuatlan', 91),\
(2883, 'Santa Lucia Monteverde', 91),\
(2884, 'Santa Lucia Ocotlan', 91),\
(2885, 'Santa Magdalena Jicotlan', 91),\
(2886, 'Santa Maria Alotepec', 91),\
(2887, 'Santa Maria Apazco', 91),\
(2888, 'Santa Maria Atzompa', 91),\
(2889, 'Santa Maria Camotlan', 91),\
(2890, 'Santa Maria Chachoapam', 91),\
(2891, 'Santa Maria Chilchotla', 91),\
(2892, 'Santa Maria Chimalapa', 91),\
(2893, 'Santa Maria Colotepec', 91),\
(2894, 'Santa Maria Cortijo', 91),\
(2895, 'Santa Maria Coyotepec', 91),\
(2896, 'Santa Maria del Rosario', 91),\
(2897, 'Santa Maria del Tule', 91),\
(2898, 'Santa Maria Ecatepec', 91),\
(2899, 'Santa Maria Guelace', 91),\
(2900, 'Santa Maria Guienagati', 91),\
(2901, 'Santa Maria Huatulco', 91),\
(2902, 'Santa Maria Huazolotitlan', 91),\
(2903, 'Santa Maria Ipalapa', 91),\
(2904, 'Santa Maria Ixcatlan', 91),\
(2905, 'Santa Maria Jacatepec', 91),\
(2906, 'Santa Maria Jalapa del Marques', 91),\
(2907, 'Santa Maria Jaltianguis', 91),\
(2908, 'Santa Maria la Asuncion', 91),\
(2909, 'Santa Maria Lachixio', 91),\
(2910, 'Santa Maria Mixtequilla', 91),\
(2911, 'Santa Maria Nativitas', 91),\
(2912, 'Santa Maria Nduayaco', 91),\
(2913, 'Santa Maria Ozolotepec', 91),\
(2914, 'Santa Maria Papalo', 91),\
(2915, 'Santa Maria Pe\'f1oles', 91),\
(2916, 'Santa Maria Petapa', 91),\
(2917, 'Santa Maria Quiegolani', 91),\
(2918, 'Santa Maria Sola', 91),\
(2919, 'Santa Maria Tataltepec', 91),\
(2920, 'Santa Maria Tecomavaca', 91),\
(2921, 'Santa Maria Temaxcalapa', 91),\
(2922, 'Santa Maria Temaxcaltepec', 91),\
(2923, 'Santa Maria Teopoxco', 91),\
(2924, 'Santa Maria Tepantlali', 91),\
(2925, 'Santa Maria Texcatitlan', 91),\
(2926, 'Santa Maria Tlahuitoltepec', 91),\
(2927, 'Santa Maria Tlalixtac', 91),\
(2928, 'Santa Maria Tonameca', 91),\
(2929, 'Santa Maria Totolapilla', 91),\
(2930, 'Santa Maria Xadani', 91),\
(2931, 'Santa Maria Yalina', 91),\
(2932, 'Santa Maria Yavesia', 91),\
(2933, 'Santa Maria Yolotepec', 91),\
(2934, 'Santa Maria Yosoyua', 91),\
(2935, 'Santa Maria Yucuhiti', 91),\
(2936, 'Santa Maria Zacatepec', 91),\
(2937, 'Santa Maria Zaniza', 91),\
(2938, 'Santa Maria Zoquitlan', 91),\
(2939, 'Santiago Amoltepec', 91),\
(2940, 'Santiago Apoala', 91),\
(2941, 'Santiago Apostol', 91),\
(2942, 'Santiago Astata', 91),\
(2943, 'Santiago Atitlan', 91),\
(2944, 'Santiago Ayuquililla', 91),\
(2945, 'Santiago Cacaloxtepec', 91),\
(2946, 'Santiago Camotlan', 91),\
(2947, 'Santiago Chazumba', 91),\
(2948, 'Santiago Choapam', 91),\
(2949, 'Santiago Comaltepec', 91),\
(2950, 'Santiago del Rio', 91),\
(2951, 'Santiago Huajolotitlan', 91),\
(2952, 'Santiago Huauclilla', 91),\
(2953, 'Santiago Ihuitlan Plumas', 91),\
(2954, 'Santiago Ixcuintepec', 91),\
(2955, 'Santiago Ixtayutla', 91),\
(2956, 'Santiago Jamiltepec', 91),\
(2957, 'Santiago Jocotepec', 91),\
(2958, 'Santiago Juxtlahuaca', 91),\
(2959, 'Santiago Lachiguiri', 91),\
(2960, 'Santiago Lalopa', 91),\
(2961, 'Santiago Laollaga', 91),\
(2962, 'Santiago Laxopa', 91),\
(2963, 'Santiago Llano Grande', 91),\
(2964, 'Santiago Matatlan', 91),\
(2965, 'Santiago Miltepec', 91),\
(2966, 'Santiago Minas', 91),\
(2967, 'Santiago Nacaltepec', 91),\
(2968, 'Santiago Nejapilla', 91),\
(2969, 'Santiago Niltepec', 91),\
(2970, 'Santiago Nundiche', 91),\
(2971, 'Santiago Nuyoo', 91),\
(2972, 'Santiago Pinotepa Nacional', 91),\
(2973, 'Santiago Suchilquitongo', 91),\
(2974, 'Santiago Tamazola', 91),\
(2975, 'Santiago Tapextla', 91),\
(2976, 'Santiago Tenango', 91),\
(2977, 'Santiago Tepetlapa', 91),\
(2978, 'Santiago Tetepec', 91),\
(2979, 'Santiago Texcalcingo', 91),\
(2980, 'Santiago Textitlan', 91),\
(2981, 'Santiago Tilantongo', 91),\
(2982, 'Santiago Tillo', 91),\
(2983, 'Santiago Tlazoyaltepec', 91),\
(2984, 'Santiago Xanica', 91),\
(2985, 'Santiago Xiacui', 91),\
(2986, 'Santiago Yaitepec', 91),\
(2987, 'Santiago Yaveo', 91),\
(2988, 'Santiago Yolomecatl', 91),\
(2989, 'Santiago Yosondua', 91),\
(2990, 'Santiago Yucuyachi', 91),\
(2991, 'Santiago Zacatepec', 91),\
(2992, 'Santiago Zoochila', 91),\
(2993, 'Santo Domingo Albarradas', 91),\
(2994, 'Santo Domingo Armenta', 91),\
(2995, 'Santo Domingo Chihuitan', 91),\
(2996, 'Santo Domingo de Morelos', 91),\
(2997, 'Santo Domingo Ingenio', 91),\
(2998, 'Santo Domingo Ixcatlan', 91),\
(2999, 'Santo Domingo Nuxaa', 91),\
(3000, 'Santo Domingo Ozolotepec', 91),\
(3001, 'Santo Domingo Petapa', 91),\
(3002, 'Santo Domingo Roayaga', 91),\
(3003, 'Santo Domingo Tehuantepec', 91),\
(3004, 'Santo Domingo Teojomulco', 91),\
(3005, 'Santo Domingo Tepuxtepec', 91),\
(3006, 'Santo Domingo Tlatayapam', 91),\
(3007, 'Santo Domingo Tomaltepec', 91),\
(3008, 'Santo Domingo Tonala', 91),\
(3009, 'Santo Domingo Tonaltepec', 91),\
(3010, 'Santo Domingo Xagacia', 91),\
(3011, 'Santo Domingo Yanhuitlan', 91),\
(3012, 'Santo Domingo Yodohino', 91),\
(3013, 'Santo Domingo Zanatepec', 91),\
(3014, 'Santo Tomas Jalieza', 91),\
(3015, 'Santo Tomas Mazaltepec', 91),\
(3016, 'Santo Tomas Ocotepec', 91),\
(3017, 'Santo Tomas Tamazulapan', 91),\
(3018, 'Santos Reyes Nopala', 91),\
(3019, 'Santos Reyes Papalo', 91),\
(3020, 'Santos Reyes Tepejillo', 91),\
(3021, 'Santos Reyes Yucuna', 91),\
(3022, 'Silacayoapam', 91),\
(3023, 'Sitio de Xitlapehua', 91),\
(3024, 'Soledad Etla', 91),\
(3025, 'Tamazulapam del Espiritu Santo', 91),\
(3026, 'Tanetze de Zaragoza', 91),\
(3027, 'Taniche', 91),\
(3028, 'Tataltepec de Valaes', 91),\
(3029, 'Teococuilco de Marcos Perez', 91),\
(3030, 'Teotitlan de Flores Magon', 91),\
(3031, 'Teotitlan del Valle', 91),\
(3032, 'Teotongo', 91),\
(3033, 'Tepelmeme Villa de Morelos', 91),\
(3034, 'Tezoatlan de Segura y Luna', 91),\
(3035, 'Tlacolula de Matamoros', 91),\
(3036, 'Tlacotepec Plumas', 91),\
(3037, 'Tlalixtac de Cabrera', 91),\
(3038, 'Totontepec Villa de Morelos', 91),\
(3039, 'Trinidad Zaachila', 91),\
(3040, 'Union Hidalgo', 91),\
(3041, 'Valerio Trujano', 91),\
(3042, 'Villa de Chilapa de Diaz', 91),\
(3043, 'Villa de Etla', 91),\
(3044, 'Villa de Tamazulapam del Progreso', 91),\
(3045, 'Villa de Tututepec de Melchor Ocam', 91),\
(3046, 'Villa de Zaachila', 91),\
(3047, 'Villa Diaz Ordaz', 91),\
(3048, 'Villa Hidalgo', 91),\
(3049, 'Villa Sola de Vega', 91),\
(3050, 'Villa Talea de Castro', 91),\
(3051, 'Villa Tejupam de la Union', 91),\
(3052, 'Yaxe', 91),\
(3053, 'Yogana', 91),\
(3054, 'Yutanduchi de Guerrero', 91),\
(3055, 'Zapotitlan del Rio', 91),\
(3056, 'Zapotitlan Lagunas', 91),\
(3057, 'Zapotitlan Palmas', 91),\
(3058, 'Zimatlan de Alvarez', 91),\
(3059, 'nameAcajete', 92),\
(3060, 'Acateno', 92),\
(3061, 'Acatlan', 92),\
(3062, 'Acatzingo', 92),\
(3063, 'Acteopan', 92),\
(3064, 'Ahuacatlan', 92),\
(3065, 'Ahuatlan', 92),\
(3066, 'Ahuazotepec', 92),\
(3067, 'Ahuehuetitla', 92),\
(3068, 'Ajalpan', 92),\
(3069, 'Albino Zertuche', 92),\
(3070, 'Aljojuca', 92),\
(3071, 'Altepexi', 92),\
(3072, 'Amixtlan', 92),\
(3073, 'Amozoc', 92),\
(3074, 'Aquixtla', 92),\
(3075, 'Atempan', 92),\
(3076, 'Atexcal', 92),\
(3077, 'Atlequizayan', 92),\
(3078, 'Atlixco', 92),\
(3079, 'Atoyatempan', 92),\
(3080, 'Atzala', 92),\
(3081, 'Atzitzihuacan', 92),\
(3082, 'Atzitzintla', 92),\
(3083, 'Axutla', 92),\
(3084, 'Ayotoxco de Guerrero', 92),\
(3085, 'Calpan', 92),\
(3086, 'Caltepec', 92),\
(3087, 'Camocuautla', 92),\
(3088, 'Ca\'f1ada Morelos', 92),\
(3089, 'Caxhuacan', 92),\
(3090, 'Chalchicomula de Sesma', 92),\
(3091, 'Chapulco', 92),\
(3092, 'Chiautla', 92),\
(3093, 'Chiautzingo', 92),\
(3094, 'Chichiquila', 92),\
(3095, 'Chiconcuautla', 92),\
(3096, 'Chietla', 92),\
(3097, 'Chigmecatitlan', 92),\
(3098, 'Chignahuapan', 92),\
(3099, 'Chignautla', 92),\
(3100, 'Chila', 92),\
(3101, 'Chila de la Sal', 92),\
(3102, 'Chilchotla', 92),\
(3103, 'Chinantla', 92),\
(3104, 'Coatepec', 92),\
(3105, 'Coatzingo', 92),\
(3106, 'Cohetzala', 92),\
(3107, 'Cohuecan', 92),\
(3108, 'Coronango', 92),\
(3109, 'Coxcatlan', 92),\
(3110, 'Coyomeapan', 92),\
(3111, 'Coyotepec', 92),\
(3112, 'Cuapiaxtla de Madero', 92),\
(3113, 'Cuautempan', 92),\
(3114, 'Cuautinchan', 92),\
(3115, 'Cuautlancingo', 92),\
(3116, 'Cuayuca de Andrade', 92),\
(3117, 'Cuetzalan del Progreso', 92),\
(3118, 'Cuyoaco', 92),\
(3119, 'Domingo Arenas', 92),\
(3120, 'Eloxochitlan', 92),\
(3121, 'Epatlan', 92),\
(3122, 'Esperanza', 92),\
(3123, 'Francisco Z. Mena', 92),\
(3124, 'General Felipe ngeles', 92),\
(3125, 'Guadalupe', 92),\
(3126, 'Guadalupe Victoria', 92),\
(3127, 'Hermenegilao Galeana', 92),\
(3128, 'Honey', 92),\
(3129, 'Huaquechula', 92),\
(3130, 'Huatlatlauca', 92),\
(3131, 'Huauchinango', 92),\
(3132, 'Huehuetla', 92),\
(3133, 'Huehuetlan el Chico', 92),\
(3134, 'Huehuetlan el Grande', 92),\
(3135, 'Huejotzingo', 92),\
(3136, 'Hueyapan', 92),\
(3137, 'Hueytamalco', 92),\
(3138, 'Hueytlalpan', 92),\
(3139, 'Huitzilan de Serdan', 92),\
(3140, 'Huitziltepec', 92),\
(3141, 'Ixcamilpa de Guerrero', 92),\
(3142, 'Ixcaquixtla', 92),\
(3143, 'Ixtacamaxtitlan', 92),\
(3144, 'Ixtepec', 92),\
(3145, 'Izucar de Matamoros', 92),\
(3146, 'Jalpan', 92),\
(3147, 'Jolalpan', 92),\
(3148, 'Jonotla', 92),\
(3149, 'Jopala', 92),\
(3150, 'Juan C. Bonilla', 92),\
(3151, 'Juan Galindo', 92),\
(3152, 'Juan N. Mendez', 92),\
(3153, 'La Magdalena Tlatlauquitepec', 92),\
(3154, 'Lafragua', 92),\
(3155, 'Libres', 92),\
(3156, 'Los Reyes de Juarez', 92),\
(3157, 'Mazapiltepec de Juarez', 92),\
(3158, 'Mixtla', 92),\
(3159, 'Molcaxac', 92),\
(3160, 'Naupan', 92),\
(3161, 'Nauzontla', 92),\
(3162, 'Nealtican', 92),\
(3163, 'Nicolas Bravo', 92),\
(3164, 'Nopalucan', 92),\
(3165, 'Ocotepec', 92),\
(3166, 'Ocoyucan', 92),\
(3167, 'Olintla', 92),\
(3168, 'Oriental', 92),\
(3169, 'Pahuatlan', 92),\
(3170, 'Palmar de Bravo', 92),\
(3171, 'Pantepec', 92),\
(3172, 'Petlalcingo', 92),\
(3173, 'Piaxtla', 92),\
(3174, 'Puebla', 92),\
(3175, 'Quecholac', 92),\
(3176, 'Quimixtlan', 92),\
(3177, 'Rafael Lara Grajales', 92),\
(3178, 'San Andres Cholula', 92),\
(3179, 'San Antonio Ca\'f1ada', 92),\
(3180, 'San Diego la Mesa Tochimiltzingo', 92),\
(3181, 'San Felipe Teotlalcingo', 92),\
(3182, 'San Felipe Tepatlan', 92),\
(3183, 'San Gabriel Chilac', 92),\
(3184, 'San Gregorio Atzompa', 92),\
(3185, 'San Jeronimo Tecuanipan', 92),\
(3186, 'San Jeronimo Xayacatlan', 92),\
(3187, 'San Jose Chiapa', 92),\
(3188, 'San Jose Miahuatlan', 92),\
(3189, 'San Juan Atenco', 92),\
(3190, 'San Juan Atzompa', 92),\
(3191, 'San Martin Texmelucan', 92),\
(3192, 'San Martin Totoltepec', 92),\
(3193, 'San Matias Tlalancaleca', 92),\
(3194, 'San Miguel Ixitlan', 92),\
(3195, 'San Miguel Xoxtla', 92),\
(3196, 'San Nicolas Buenos Aires', 92),\
(3197, 'San Nicolas de los Ranchos', 92),\
(3198, 'San Pablo Anicano', 92),\
(3199, 'San Pedro Cholula', 92),\
(3200, 'San Pedro Yeloixtlahuaca', 92),\
(3201, 'San Salvador el Seco', 92),\
(3202, 'San Salvador el Verde', 92),\
(3203, 'San Salvador Huixcolotla', 92),\
(3204, 'San Sebastian Tlacotepec', 92),\
(3205, 'Santa Catarina Tlaltempan', 92),\
(3206, 'Santa Ines Ahuatempan', 92),\
(3207, 'Santa Isabel Cholula', 92),\
(3208, 'Santiago Miahuatlan', 92),\
(3209, 'Santo Tomas Hueyotlipan', 92),\
(3210, 'Soltepec', 92),\
(3211, 'Tecali de Herrera', 92),\
(3212, 'Tecamachalco', 92),\
(3213, 'Tecomatlan', 92),\
(3214, 'Tehuacan', 92),\
(3215, 'Tehuitzingo', 92),\
(3216, 'Tenampulco', 92),\
(3217, 'Teopantlan', 92),\
(3218, 'Teotlalco', 92),\
(3219, 'Tepanco de Lopez', 92),\
(3220, 'Tepango de Rodriguez', 92),\
(3221, 'Tepatlaxco de Hidalgo', 92),\
(3222, 'Tepeaca', 92),\
(3223, 'Tepemaxalco', 92),\
(3224, 'Tepeojuma', 92),\
(3225, 'Tepetzintla', 92),\
(3226, 'Tepexco', 92),\
(3227, 'Tepexi de Rodriguez', 92),\
(3228, 'Tepeyahualco', 92),\
(3229, 'Tepeyahualco de Cuauhtemoc', 92),\
(3230, 'Tetela de Ocampo', 92),\
(3231, 'Teteles de Avila Castillo', 92),\
(3232, 'Teziutlan', 92),\
(3233, 'Tianguismanalco', 92),\
(3234, 'Tilapa', 92),\
(3235, 'Tlachichuca', 92),\
(3236, 'Tlacotepec de Benito Juarez', 92),\
(3237, 'Tlacuilotepec', 92),\
(3238, 'Tlahuapan', 92),\
(3239, 'Tlaltenango', 92),\
(3240, 'Tlanepantla', 92),\
(3241, 'Tlaola', 92),\
(3242, 'Tlapacoya', 92),\
(3243, 'Tlapanala', 92),\
(3244, 'Tlatlauquitepec', 92),\
(3245, 'Tlaxco', 92),\
(3246, 'Tochimilco', 92),\
(3247, 'Tochtepec', 92),\
(3248, 'Totoltepec de Guerrero', 92),\
(3249, 'Tulcingo', 92),\
(3250, 'Tuzamapan de Galeana', 92),\
(3251, 'Tzicatlacoyan', 92),\
(3252, 'Venustiano Carranza', 92),\
(3253, 'Vicente Guerrero', 92),\
(3254, 'Xayacatlan de Bravo', 92),\
(3255, 'Xicotepec', 92),\
(3256, 'Xicotlan', 92),\
(3257, 'Xiutetelco', 92),\
(3258, 'Xochiapulco', 92),\
(3259, 'Xochiltepec', 92),\
(3260, 'Xochitlan de Vicente Suarez', 92),\
(3261, 'Xochitlan Todos Santos', 92),\
(3262, 'Yaonahuac', 92),\
(3263, 'Yehualtepec', 92),\
(3264, 'Zacapala', 92),\
(3265, 'Zacapoaxtla', 92),\
(3266, 'Zacatlan', 92),\
(3267, 'Zapotitlan', 92),\
(3268, 'Zapotitlan de Mendez', 92),\
(3269, 'Zaragoza', 92),\
(3270, 'Zautla', 92),\
(3271, 'Zihuateutla', 92),\
(3272, 'Zinacatepec', 92),\
(3273, 'Zongozotla', 92),\
(3274, 'Zoquiapan', 92),\
(3275, 'Zoquitlan', 92),\
(3276, 'Amealco de Bonfil', 93),\
(3277, 'Arroyo Seco', 93),\
(3278, 'Cadereyta de Montes', 93),\
(3279, 'Colon', 93),\
(3280, 'Corregidora', 93),\
(3281, 'El Marques', 93),\
(3282, 'Ezequiel Montes', 93),\
(3283, 'Huimilpan', 93),\
(3284, 'Jalpan de Serra', 93),\
(3285, 'Landa de Matamoros', 93),\
(3286, 'Pedro Escobedo', 93),\
(3287, 'Pe\'f1amiller', 93),\
(3288, 'Pinal de Amoles', 93),\
(3289, 'Queretaro', 93),\
(3290, 'San Joaquin', 93),\
(3291, 'San Juan del Rio', 93),\
(3292, 'Tequisquiapan', 93),\
(3293, 'Toliman', 93),\
(3294, 'Benito Juarez', 94),\
(3295, 'Cozumel', 94),\
(3296, 'Felipe Carrillo Puerto', 94),\
(3297, 'Isla Mujeres', 94),\
(3298, 'Jose Maria Morelos', 94),\
(3299, 'Lazaro Cardenas', 94),\
(3300, 'Othon P. Blanco', 94),\
(3301, 'Solidaridad', 94),\
(3302, 'Ahualulco', 95),\
(3303, 'Alaquines', 95),\
(3304, 'Aquismon', 95),\
(3305, 'Armadillo de los Infante', 95),\
(3306, 'Axtla de Terrazas', 95),\
(3307, 'Cardenas', 95),\
(3308, 'Catorce', 95),\
(3309, 'Cedral', 95),\
(3310, 'Cerritos', 95),\
(3311, 'Cerro de San Pedro', 95),\
(3312, 'Charcas', 95),\
(3313, 'Ciudad del Maiz', 95),\
(3314, 'Ciudad Fernandez', 95),\
(3315, 'Ciudad Valles', 95),\
(3316, 'Coxcatlan', 95),\
(3317, 'Ebano', 95),\
(3318, 'El Naranjo', 95),\
(3319, 'Guadalcazar', 95),\
(3320, 'Huehuetlan', 95),\
(3321, 'Lagunillas', 95),\
(3322, 'Matehuala', 95),\
(3323, 'Matlapa', 95),\
(3324, 'Mexquitic de Carmona', 95),\
(3325, 'Moctezuma', 95),\
(3326, 'Rayon', 95),\
(3327, 'Rioverde', 95),\
(3328, 'Salinas', 95),\
(3329, 'San Antonio', 95),\
(3330, 'San Ciro de Acosta', 95),\
(3331, 'San Luis Potosi', 95),\
(3332, 'San Martin Chalchicuautla', 95),\
(3333, 'San Nicolas Tolentino', 95),\
(3334, 'San Vicente Tancuayalab', 95),\
(3335, 'Santa Catarina', 95),\
(3336, 'Santa Maria del Rio', 95),\
(3337, 'Santo Domingo', 95),\
(3338, 'Soledad de Graciano Sanchez', 95),\
(3339, 'Tamasopo', 95),\
(3340, 'Tamazunchale', 95),\
(3341, 'Tampacan', 95),\
(3342, 'Tampamolon Corona', 95),\
(3343, 'Tamuin', 95),\
(3344, 'Tancanhuitz', 95),\
(3345, 'Tanlajas', 95),\
(3346, 'Tanquian de Escobedo', 95),\
(3347, 'Tierra Nueva', 95),\
(3348, 'Vanegas', 95),\
(3349, 'Venado', 95),\
(3350, 'Villa de Arista', 95),\
(3351, 'Villa de Arriaga', 95),\
(3352, 'Villa de Guadalupe', 95),\
(3353, 'Villa de la Paz', 95),\
(3354, 'Villa de Ramos', 95),\
(3355, 'Villa de Reyes', 95),\
(3356, 'Villa Hidalgo', 95),\
(3357, 'Villa Juarez', 95),\
(3358, 'Xilitla', 95),\
(3359, 'Zaragoza', 95),\
(3360, 'Ahome', 96),\
(3361, 'Angostura', 96),\
(3362, 'Badiraguato', 96),\
(3363, 'Choix', 96),\
(3364, 'Concordia', 96),\
(3365, 'Cosala', 96),\
(3366, 'Culiacan', 96),\
(3367, 'El Fuerte', 96),\
(3368, 'Elota', 96),\
(3369, 'Escuinapa', 96),\
(3370, 'Guasave', 96),\
(3371, 'Mazatlan', 96),\
(3372, 'Mocorito', 96),\
(3373, 'Navolato', 96),\
(3374, 'Rosario', 96),\
(3375, 'Salvador Alvarado', 96),\
(3376, 'San Ignacio', 96),\
(3377, 'Sinaloa', 96),\
(3378, 'Aconchi', 97),\
(3379, 'Agua Prieta', 97),\
(3380, 'Alamos', 97),\
(3381, 'Altar', 97),\
(3382, 'Arivechi', 97),\
(3383, 'Arizpe', 97),\
(3384, 'Atil', 97),\
(3385, 'Bacadehuachi', 97),\
(3386, 'Bacanora', 97),\
(3387, 'Bacerac', 97),\
(3388, 'Bacoachi', 97),\
(3389, 'Bacum', 97),\
(3390, 'Banamichi', 97),\
(3391, 'Baviacora', 97),\
(3392, 'Bavispe', 97),\
(3393, 'Benito Juarez', 97),\
(3394, 'Benjamin Hill', 97),\
(3395, 'Caborca', 97),\
(3396, 'Cajeme', 97),\
(3397, 'Cananea', 97),\
(3398, 'Carbo', 97),\
(3399, 'Cucurpe', 97),\
(3400, 'Cumpas', 97),\
(3401, 'Divisaderos', 97),\
(3402, 'Empalme', 97),\
(3403, 'Etchojoa', 97),\
(3404, 'Fronteras', 97),\
(3405, 'General Plutarco Elias Calles', 97),\
(3406, 'Granados', 97),\
(3407, 'Guaymas', 97),\
(3408, 'Hermosillo', 97),\
(3409, 'Heroica Nogales', 97),\
(3410, 'Huachinera', 97),\
(3411, 'Huasabas', 97),\
(3412, 'Huatabampo', 97),\
(3413, 'Huepac', 97),\
(3414, 'Imuris', 97),\
(3415, 'La Colorada', 97),\
(3416, 'Magdalena', 97),\
(3417, 'Mazatan', 97),\
(3418, 'Moctezuma', 97),\
(3419, 'Naco', 97),\
(3420, 'Nacori Chico', 97),\
(3421, 'Nacozari de Garcia', 97),\
(3422, 'Navojoa', 97),\
(3423, 'Onavas', 97),\
(3424, 'Opodepe', 97),\
(3425, 'Oquitoa', 97),\
(3426, 'Pitiquito', 97),\
(3427, 'Puerto Pe\'f1asco', 97),\
(3428, 'Quiriego', 97),\
(3429, 'Rayon', 97),\
(3430, 'Rosario', 97),\
(3431, 'Sahuaripa', 97),\
(3432, 'San Felipe de Jesus', 97),\
(3433, 'San Ignacio Rio Muerto', 97),\
(3434, 'San Javier', 97),\
(3435, 'San Luis Rio Colorado', 97),\
(3436, 'San Miguel de Horcasitas', 97),\
(3437, 'San Pedro de la Cueva', 97),\
(3438, 'Santa Ana', 97),\
(3439, 'Santa Cruz', 97),\
(3440, 'Saric', 97),\
(3441, 'Soyopa', 97),\
(3442, 'Suaqui Grande', 97),\
(3443, 'Tepache', 97),\
(3444, 'Trincheras', 97),\
(3445, 'Tubutama', 97),\
(3446, 'Ures', 97),\
(3447, 'Villa Hidalgo', 97),\
(3448, 'Villa Pesqueira', 97),\
(3449, 'Yecora', 97),\
(3450, 'Balancan', 98),\
(3451, 'Cardenas', 98),\
(3452, 'Centla', 98),\
(3453, 'Centro', 98),\
(3454, 'Comalcalco', 98),\
(3455, 'Cunduacan', 98),\
(3456, 'Emiliano Zapata', 98),\
(3457, 'Huimanguillo', 98),\
(3458, 'Jalapa', 98),\
(3459, 'Jalpa de Mendez', 98),\
(3460, 'Jonuta', 98),\
(3461, 'Macuspana', 98),\
(3462, 'Nacajuca', 98),\
(3463, 'Paraiso', 98),\
(3464, 'Tacotalpa', 98),\
(3465, 'Teapa', 98),\
(3466, 'Tenosique', 98),\
(3467, 'Abasolo', 99),\
(3468, 'Alaama', 99),\
(3469, 'Altamira', 99),\
(3470, 'Antiguo Morelos', 99),\
(3471, 'Burgos', 99),\
(3472, 'Bustamante', 99),\
(3473, 'Camargo', 99),\
(3474, 'Casas', 99),\
(3475, 'Ciudad Madero', 99),\
(3476, 'Cruillas', 99),\
(3477, 'El Mante', 99),\
(3478, 'Gemez', 99),\
(3479, 'Gomez Farias', 99),\
(3480, 'Gonzalez', 99),\
(3481, 'Guerrero', 99),\
(3482, 'Gustavo Diaz Ordaz', 99),\
(3483, 'Hidalgo', 99),\
(3484, 'Jaumave', 99),\
(3485, 'Jimenez', 99),\
(3486, 'Llera', 99),\
(3487, 'Mainero', 99),\
(3488, 'Matamoros', 99),\
(3489, 'Mendez', 99),\
(3490, 'Mier', 99),\
(3491, 'Miguel Aleman', 99),\
(3492, 'Miquihuana', 99),\
(3493, 'Nuevo Laredo', 99),\
(3494, 'Nuevo Morelos', 99),\
(3495, 'Ocampo', 99),\
(3496, 'Padilla', 99),\
(3497, 'Palmillas', 99),\
(3498, 'Reynosa', 99),\
(3499, 'Rio Bravo', 99),\
(3500, 'San Carlos', 99),\
(3501, 'San Fernando', 99),\
(3502, 'San Nicolas', 99),\
(3503, 'Soto la Marina', 99),\
(3504, 'Tampico', 99),\
(3505, 'Tula', 99),\
(3506, 'Valle Hermoso', 99),\
(3507, 'Victoria', 99),\
(3508, 'Villagran', 99),\
(3509, 'Xicotencatl', 99),\
(3510, 'Acuamanala de Miguel Hidalgo', 100),\
(3511, 'Altzayanca', 100),\
(3512, 'Amaxac de Guerrero', 100),\
(3513, 'Apetatitlan de Antonio Carvajal', 100),\
(3514, 'Apizaco', 100),\
(3515, 'Atlangatepec', 100),\
(3516, 'Benito Juarez', 100),\
(3517, 'Calpulalpan', 100),\
(3518, 'Chiautempan', 100),\
(3519, 'Contla de Juan Cuamatzi', 100),\
(3520, 'Cuapiaxtla', 100),\
(3521, 'Cuaxomulco', 100),\
(3522, 'El Carmen Tequexquitla', 100),\
(3523, 'Emiliano Zapata', 100),\
(3524, 'Espa\'f1ita', 100),\
(3525, 'Huamantla', 100),\
(3526, 'Hueyotlipan', 100),\
(3527, 'Ixtacuixtla de Mariano Matamoros', 100),\
(3528, 'Ixtenco', 100),\
(3529, 'La Magdalena Tlaltelulco', 100),\
(3530, 'Lazaro Cardenas', 100),\
(3531, 'Mazatecochco de Jose Maria Morelos', 100),\
(3532, 'Mu\'f1oz de Domingo Arenas', 100),\
(3533, 'Nanacamilpa de Mariano Arista', 100),\
(3534, 'Nativitas', 100),\
(3535, 'Panotla', 100),\
(3536, 'Papalotla de Xicohtencatl', 100),\
(3537, 'San Damian Texoloc', 100),\
(3538, 'San Francisco Tetlanohcan', 100),\
(3539, 'San Jeronimo Zacualpan', 100),\
(3540, 'San Jose Teacalco', 100),\
(3541, 'San Juan Huactzinco', 100),\
(3542, 'San Lorenzo Axocomanitla', 100),\
(3543, 'San Lucas Tecopilco', 100),\
(3544, 'San Pablo del Monte', 100),\
(3545, 'Sanctorum de Lazaro Cardenas', 100),\
(3546, 'Santa Ana Nopalucan', 100),\
(3547, 'Santa Apolonia Teacalco', 100),\
(3548, 'Santa Catarina Ayometla', 100),\
(3549, 'Santa Cruz Quilehtla', 100),\
(3550, 'Santa Cruz Tlaxcala', 100),\
(3551, 'Santa Isabel Xiloxoxtla', 100),\
(3552, 'Tenancingo', 100),\
(3553, 'Teolocholco', 100),\
(3554, 'Tepetitla de Lardizabal', 100),\
(3555, 'Tepeyanco', 100),\
(3556, 'Terrenate', 100),\
(3557, 'Tetla de la Solidaridad', 100),\
(3558, 'Tetlatlahuca', 100),\
(3559, 'Tlaxcala', 100),\
(3560, 'Tlaxco', 100),\
(3561, 'Tocatlan', 100),\
(3562, 'Totolac', 100),\
(3563, 'Tzompantepec', 100),\
(3564, 'Xaloztoc', 100),\
(3565, 'Xaltocan', 100),\
(3566, 'Xicohtzinco', 100),\
(3567, 'Yauhquemecan', 100),\
(3568, 'Zacatelco', 100),\
(3569, 'Zitlaltepec de Trinidad Sanchez Sa', 100),\
(3570, 'Acajete', 101),\
(3571, 'Acatlan', 101),\
(3572, 'Acayucan', 101),\
(3573, 'Actopan', 101),\
(3574, 'Acula', 101),\
(3575, 'Acultzingo', 101),\
(3576, 'Agua Dulce', 101),\
(3577, 'Alpatlahuac', 101),\
(3578, 'Alto Lucero de Gutierrez Barrios', 101),\
(3579, 'Altotonga', 101),\
(3580, 'Alvarado', 101),\
(3581, 'Amatitlan', 101),\
(3582, 'Amatlan de los Reyes', 101),\
(3583, 'Angel R. Cabada', 101),\
(3584, 'Apazapan', 101),\
(3585, 'Aquila', 101),\
(3586, 'Astacinga', 101),\
(3587, 'Atlahuilco', 101),\
(3588, 'Atoyac', 101),\
(3589, 'Atzacan', 101),\
(3590, 'Atzalan', 101),\
(3591, 'Ayahualulco', 101),\
(3592, 'Banderilla', 101),\
(3593, 'Benito Juarez', 101),\
(3594, 'Boca del Rio', 101),\
(3595, 'Calcahualco', 101),\
(3596, 'Camaron de Tejeda', 101),\
(3597, 'Camerino Z. Mendoza', 101),\
(3598, 'Carlos A. Carrillo', 101),\
(3599, 'Carrillo Puerto', 101),\
(3600, 'Castillo de Teayo', 101),\
(3601, 'Catemaco', 101),\
(3602, 'Cazones', 101),\
(3603, 'Cerro Azul', 101),\
(3604, 'Chacaltianguis', 101),\
(3605, 'Chalma', 101),\
(3606, 'Chiconamel', 101),\
(3607, 'Chiconquiaco', 101),\
(3608, 'Chicontepec', 101),\
(3609, 'Chinameca', 101),\
(3610, 'Chinampa de Gorostiza', 101),\
(3611, 'Chocaman', 101),\
(3612, 'Chontla', 101),\
(3613, 'Chumatlan', 101),\
(3614, 'Citlaltepetl', 101),\
(3615, 'Coacoatzintla', 101),\
(3616, 'Coahuitlan', 101),\
(3617, 'Coatepec', 101),\
(3618, 'Coatzacoalcos', 101),\
(3619, 'Coatzintla', 101),\
(3620, 'Coetzala', 101),\
(3621, 'Colipa', 101),\
(3622, 'Comapa', 101),\
(3623, 'Cordoba', 101),\
(3624, 'Cosamaloapan de Carpio', 101),\
(3625, 'Cosautlan de Carvajal', 101),\
(3626, 'Coscomatepec', 101),\
(3627, 'Cosoleacaque', 101),\
(3628, 'Cotaxtla', 101),\
(3629, 'Coxquihui', 101),\
(3630, 'Coyutla', 101),\
(3631, 'Cuichapa', 101),\
(3632, 'Cuitlahuac', 101),\
(3633, 'El Higo', 101),\
(3634, 'Emiliano Zapata', 101),\
(3635, 'Espinal', 101),\
(3636, 'Filomeno Mata', 101),\
(3637, 'Fortin', 101),\
(3638, 'Gutierrez Zamora', 101),\
(3639, 'Hidalgotitlan', 101),\
(3640, 'Huatusco', 101),\
(3641, 'Huayacocotla', 101),\
(3642, 'Hueyapan de Ocampo', 101),\
(3643, 'Huiloapan', 101),\
(3644, 'Ignacio de la Llave', 101),\
(3645, 'Ilamatlan', 101),\
(3646, 'Isla', 101),\
(3647, 'Ixcatepec', 101),\
(3648, 'Ixhuacan de los Reyes', 101),\
(3649, 'Ixhuatlan de Madero', 101),\
(3650, 'Ixhuatlan del Cafe', 101),\
(3651, 'Ixhuatlan del Sureste', 101),\
(3652, 'Ixhuatlancillo', 101),\
(3653, 'Ixmatlahuacan', 101),\
(3654, 'Ixtaczoquitlan', 101),\
(3655, 'Jalacingo', 101),\
(3656, 'Jalcomulco', 101),\
(3657, 'Jaltipan', 101),\
(3658, 'Jamapa', 101),\
(3659, 'Jesus Carranza', 101),\
(3660, 'Jilotepec', 101),\
(3661, 'Jose Azueta', 101),\
(3662, 'Juan Rodriguez Clara', 101),\
(3663, 'Juchique de Ferrer', 101),\
(3664, 'La Antigua', 101),\
(3665, 'La Perla', 101),\
(3666, 'Landero y Coss', 101),\
(3667, 'Las Choapas', 101),\
(3668, 'Las Minas', 101),\
(3669, 'Las Vigas de Ramirez', 101),\
(3670, 'Lerdo de Tejada', 101),\
(3671, 'Los Reyes', 101),\
(3672, 'Magdalena', 101),\
(3673, 'Maltrata', 101),\
(3674, 'Manlio Fabio Altamirano', 101),\
(3675, 'Mariano Escobedo', 101),\
(3676, 'Martinez de la Torre', 101),\
(3677, 'Mecatlan', 101),\
(3678, 'Mecayapan', 101),\
(3679, 'Medellin', 101),\
(3680, 'Miahuatlan', 101),\
(3681, 'Minatitlan', 101),\
(3682, 'Misantla', 101),\
(3683, 'Mixtla de Altamirano', 101),\
(3684, 'Moloacan', 101),\
(3685, 'Nanchital de Lazaro Cardenas del R', 101),\
(3686, 'Naolinco', 101),\
(3687, 'Naranjal', 101),\
(3688, 'Naranjos Amatlan', 101),\
(3689, 'Nautla', 101),\
(3690, 'Nogales', 101),\
(3691, 'Oluta', 101),\
(3692, 'Omealca', 101),\
(3693, 'Orizaba', 101),\
(3694, 'Otatitlan', 101),\
(3695, 'Oteapan', 101),\
(3696, 'Ozuluama de Mascare\'f1as', 101),\
(3697, 'Pajapan', 101),\
(3698, 'Panuco', 101),\
(3699, 'Papantla', 101),\
(3700, 'Paso de Ovejas', 101),\
(3701, 'Paso del Macho', 101),\
(3702, 'Perote', 101),\
(3703, 'Platon Sanchez', 101),\
(3704, 'Playa Vicente', 101),\
(3705, 'Poza Rica de Hidalgo', 101),\
(3706, 'Pueblo Viejo', 101),\
(3707, 'Puente Nacional', 101),\
(3708, 'Rafael Delgado', 101),\
(3709, 'Rafael Lucio', 101),\
(3710, 'Rio Blanco', 101),\
(3711, 'Saltabarranca', 101),\
(3712, 'San Andres Tenejapan', 101),\
(3713, 'San Andres Tuxtla', 101),\
(3714, 'San Juan Evangelista', 101),\
(3715, 'San Rafael', 101),\
(3716, 'Santiago Sochiapan', 101),\
(3717, 'Santiago Tuxtla', 101),\
(3718, 'Sayula de Aleman', 101),\
(3719, 'Sochiapa', 101),\
(3720, 'Soconusco', 101),\
(3721, 'Soledad Atzompa', 101),\
(3722, 'Soledad de Doblado', 101),\
(3723, 'Soteapan', 101),\
(3724, 'Tamalin', 101),\
(3725, 'Tamiahua', 101),\
(3726, 'Tampico Alto', 101),\
(3727, 'Tancoco', 101),\
(3728, 'Tantima', 101),\
(3729, 'Tantoyuca', 101),\
(3730, 'Tatahuicapan de Juarez', 101),\
(3731, 'Tatatila', 101),\
(3732, 'Tecolutla', 101),\
(3733, 'Tehuipango', 101),\
(3734, 'Temapache', 101),\
(3735, 'Tempoal', 101),\
(3736, 'Tenampa', 101),\
(3737, 'Tenochtitlan', 101),\
(3738, 'Teocelo', 101),\
(3739, 'Tepatlaxco', 101),\
(3740, 'Tepetlan', 101),\
(3741, 'Tepetzintla', 101),\
(3742, 'Tequila', 101),\
(3743, 'Texcatepec', 101),\
(3744, 'Texhuacan', 101),\
(3745, 'Texistepec', 101),\
(3746, 'Tezonapa', 101),\
(3747, 'Tierra Blanca', 101),\
(3748, 'Tihuatlan', 101),\
(3749, 'Tlachichilco', 101),\
(3750, 'Tlacojalpan', 101),\
(3751, 'Tlacolulan', 101),\
(3752, 'Tlacotalpan', 101),\
(3753, 'Tlacotepec de Mejia', 101),\
(3754, 'Tlalixcoyan', 101),\
(3755, 'Tlalnelhuayocan', 101),\
(3756, 'Tlaltetela', 101),\
(3757, 'Tlapacoyan', 101),\
(3758, 'Tlaquilpa', 101),\
(3759, 'Tlilapan', 101),\
(3760, 'Tomatlan', 101),\
(3761, 'Tonayan', 101),\
(3762, 'Totutla', 101),\
(3763, 'Tres Valles', 101),\
(3764, 'Tuxpam', 101),\
(3765, 'Tuxtilla', 101),\
(3766, 'Ursulo Galvan', 101),\
(3767, 'Uxpanapa', 101),\
(3768, 'Vega de Alatorre', 101),\
(3769, 'Veracruz', 101),\
(3770, 'Villa Alaama', 101),\
(3771, 'Xalapa', 101),\
(3772, 'Xico', 101),\
(3773, 'Xoxocotla', 101),\
(3774, 'Yanga', 101),\
(3775, 'Yecuatla', 101),\
(3776, 'Zacualpan', 101),\
(3777, 'Zaragoza', 101),\
(3778, 'Zentla', 101),\
(3779, 'Zongolica', 101),\
(3780, 'Zontecomatlan de Lopez y Fuentes', 101),\
(3781, 'Zozocolco de Hidalgo', 101),\
(3782, 'Abala', 102),\
(3783, 'Acanceh', 102),\
(3784, 'Akil', 102),\
(3785, 'Baca', 102),\
(3786, 'Bokoba', 102),\
(3787, 'Buctzotz', 102),\
(3788, 'Cacalchen', 102),\
(3789, 'Calotmul', 102),\
(3790, 'Cansahcab', 102),\
(3791, 'Cantamayec', 102),\
(3792, 'Celestun', 102),\
(3793, 'Cenotillo', 102),\
(3794, 'Chacsinkin', 102),\
(3795, 'Chankom', 102),\
(3796, 'Chapab', 102),\
(3797, 'Chemax', 102),\
(3798, 'Chichimila', 102),\
(3799, 'Chicxulub Pueblo', 102),\
(3800, 'Chikindzonot', 102),\
(3801, 'Chochola', 102),\
(3802, 'Chumayel', 102),\
(3803, 'Conkal', 102),\
(3804, 'Cuncunul', 102),\
(3805, 'Cuzama', 102),\
(3806, 'Dzan', 102),\
(3807, 'Dzemul', 102),\
(3808, 'Dzidzantun', 102),\
(3809, 'Dzilam de Bravo', 102),\
(3810, 'Dzilam Gonzalez', 102),\
(3811, 'Dzitas', 102),\
(3812, 'Dzoncauich', 102),\
(3813, 'Espita', 102),\
(3814, 'Halacho', 102),\
(3815, 'Hocaba', 102),\
(3816, 'Hoctun', 102),\
(3817, 'Homun', 102),\
(3818, 'Huhi', 102),\
(3819, 'Hunucma', 102),\
(3820, 'Ixil', 102),\
(3821, 'Izamal', 102),\
(3822, 'Kanasin', 102),\
(3823, 'Kantunil', 102),\
(3824, 'Kaua', 102),\
(3825, 'Kinchil', 102),\
(3826, 'Kopoma', 102),\
(3827, 'Mama', 102),\
(3828, 'Mani', 102),\
(3829, 'Maxcanu', 102),\
(3830, 'Mayapan', 102),\
(3831, 'Merida', 102),\
(3832, 'Motul', 102),\
(3833, 'Muna', 102),\
(3834, 'Muxupip', 102),\
(3835, 'Opichen', 102),\
(3836, 'Oxkutzcab', 102),\
(3837, 'Panaba', 102),\
(3838, 'Peto', 102),\
(3839, 'Progreso', 102),\
(3840, 'Quintana Roo', 102),\
(3841, 'Rio Lagartos', 102),\
(3842, 'Sacalum', 102),\
(3843, 'Samahil', 102),\
(3844, 'San Felipe', 102),\
(3845, 'Sanahcat', 102),\
(3846, 'Santa Elena', 102),\
(3847, 'Seye', 102),\
(3848, 'Sinanche', 102),\
(3849, 'Sotuta', 102),\
(3850, 'Sucila', 102),\
(3851, 'Sudzal', 102),\
(3852, 'Suma', 102),\
(3853, 'Tahdziu', 102),\
(3854, 'Tahmek', 102),\
(3855, 'Teabo', 102),\
(3856, 'Tecoh', 102),\
(3857, 'Tekal de Venegas', 102),\
(3858, 'Tekanto', 102),\
(3859, 'Tekax', 102),\
(3860, 'Tekit', 102),\
(3861, 'Tekom', 102),\
(3862, 'Telchac Pueblo', 102),\
(3863, 'Telchac Puerto', 102),\
(3864, 'Temax', 102),\
(3865, 'Temozon', 102),\
(3866, 'Tepakan', 102),\
(3867, 'Tetiz', 102),\
(3868, 'Teya', 102),\
(3869, 'Ticul', 102),\
(3870, 'Timucuy', 102),\
(3871, 'Tinum', 102),\
(3872, 'Tixcacalcupul', 102),\
(3873, 'Tixkokob', 102),\
(3874, 'Tixmehuac', 102),\
(3875, 'Tixpehual', 102),\
(3876, 'Tizimin', 102),\
(3877, 'Tunkas', 102),\
(3878, 'Tzucacab', 102),\
(3879, 'Uayma', 102),\
(3880, 'Ucu', 102),\
(3881, 'Uman', 102),\
(3882, 'Valladolid', 102),\
(3883, 'Xocchel', 102),\
(3884, 'Yaxcaba', 102),\
(3885, 'Yaxkukul', 102),\
(3886, 'Yobain', 102),\
(3887, 'Apozol', 103),\
(3888, 'Apulco', 103),\
(3889, 'Atolinga', 103),\
(3890, 'Benito Juarez', 103),\
(3891, 'Calera', 103),\
(3892, 'Ca\'f1itas de Felipe Pescador', 103),\
(3893, 'Chalchihuites', 103),\
(3894, 'Concepcion del Oro', 103),\
(3895, 'Cuauhtemoc', 103),\
(3896, 'El Plateado de Joaquin Amaro', 103),\
(3897, 'El Salvador', 103),\
(3898, 'Fresnillo', 103),\
(3899, 'Genaro Codina', 103),\
(3900, 'General Enrique Estrada', 103),\
(3901, 'General Francisco R. Murguia', 103),\
(3902, 'General Panfilo Natera', 103),\
(3903, 'Guadalupe', 103),\
(3904, 'Huanusco', 103),\
(3905, 'Jalpa', 103),\
(3906, 'Jerez', 103);\
INSERT INTO `cities` (`id`, `name`, `region_id`) VALUES\
(3907, 'Jimenez del Teul', 103),\
(3908, 'Juan Alaama', 103),\
(3909, 'Juchipila', 103),\
(3910, 'Loreto', 103),\
(3911, 'Luis Moya', 103),\
(3912, 'Mazapil', 103),\
(3913, 'Melchor Ocampo', 103),\
(3914, 'Mezquital del Oro', 103),\
(3915, 'Miguel Auza', 103),\
(3916, 'Momax', 103),\
(3917, 'Monte Escobedo', 103),\
(3918, 'Morelos', 103),\
(3919, 'Moyahua de Estrada', 103),\
(3920, 'Nochistlan de Mejia', 103),\
(3921, 'Noria de ngeles', 103),\
(3922, 'Ojocaliente', 103),\
(3923, 'Panuco', 103),\
(3924, 'Pinos', 103),\
(3925, 'Rio Grande', 103),\
(3926, 'Sain Alto', 103),\
(3927, 'Santa Maria de la Paz', 103),\
(3928, 'Sombrerete', 103),\
(3929, 'Susticacan', 103),\
(3930, 'Tabasco', 103),\
(3931, 'Tepechitlan', 103),\
(3932, 'Tepetongo', 103),\
(3933, 'Teul de Gonzalez Ortega', 103),\
(3934, 'Tlaltenango de Sanchez Roman', 103),\
(3935, 'Trancoso', 103),\
(3936, 'Trinidad Garcia de la Cadena', 103),\
(3937, 'Valparaiso', 103),\
(3938, 'Vetagrande', 103),\
(3939, 'Villa de Cos', 103),\
(3940, 'Villa Garcia', 103),\
(3941, 'Villa Gonzalez Ortega', 103),\
(3942, 'Villa Hidalgo', 103),\
(3943, 'Villanueva', 103),\
(3944, 'Zacatecas', 103),\
(3945, 'A. Saravia', 104),\
(3946, 'Aguaray', 104),\
(3947, 'Angastaco', 104),\
(3948, 'Animana', 104),\
(3949, 'Cachi', 104),\
(3950, 'Cafayate', 104),\
(3951, 'Campo Quijano', 104),\
(3952, 'Campo Santo', 104),\
(3953, 'Capital', 104),\
(3954, 'Cerrillos', 104),\
(3955, 'Chicoana', 104),\
(3956, 'Col. Sta. Rosa', 104),\
(3957, 'Coronel Moldes', 104),\
(3958, 'El Bordo', 104),\
(3959, 'El Carril', 104),\
(3960, 'El Galpon', 104),\
(3961, 'El Jardin', 104),\
(3962, 'El Potrero', 104),\
(3963, 'El Quebrachal', 104),\
(3964, 'El Tala', 104),\
(3965, 'Embarcacion', 104),\
(3966, 'Gral. Ballivian', 104),\
(3967, 'Gral. Guemes', 104),\
(3968, 'Gral. Mosconi', 104),\
(3969, 'Gral. Pizarro', 104),\
(3970, 'Guachipas', 104),\
(3971, 'Hipolito Yrigoyen', 104),\
(3972, 'Iruya', 104),\
(3973, 'Isla De Canias', 104),\
(3974, 'J. V. Gonzalez', 104),\
(3975, 'La Caldera', 104),\
(3976, 'La Candelaria', 104),\
(3977, 'La Merced', 104),\
(3978, 'La Poma', 104),\
(3979, 'La Vinia', 104),\
(3980, 'Las Lajitas', 104),\
(3981, 'Los Toldos', 104),\
(3982, 'Metan', 104),\
(3983, 'Molinos', 104),\
(3984, 'Nazareno', 104),\
(3985, 'Oran', 104),\
(3986, 'Payogasta', 104),\
(3987, 'Pichanal', 104),\
(3988, 'Prof. S. Mazza', 104),\
(3989, 'Rio Piedras', 104),\
(3990, 'Rivadavia Banda Norte', 104),\
(3991, 'Rivadavia Banda Sur', 104),\
(3992, 'Rosario de La Frontera', 104),\
(3993, 'Rosario de Lerma', 104),\
(3994, 'Saclantas', 104),\
(3995, 'Salta', 104),\
(3996, 'San Antonio', 104),\
(3997, 'San Carlos', 104),\
(3998, 'San Jose De Metan', 104),\
(3999, 'San Ramon', 104),\
(4000, 'Santa Victoria E.', 104),\
(4001, 'Santa Victoria O.', 104),\
(4002, 'Tartagal', 104),\
(4003, 'Tolar Grande', 104),\
(4004, 'Urundel', 104),\
(4005, 'Vaqueros', 104),\
(4006, 'Villa San Lorenzo', 104),\
(4007, '3 de febrero', 105),\
(4008, '11 de Septiembre', 105),\
(4009, '20 de Junio', 105),\
(4010, '25 de Mayo', 105),\
(4011, 'Acassuso', 105),\
(4012, 'Adrogue', 105),\
(4013, 'Aldo Bonzi', 105),\
(4014, 'A. Alsina', 105),\
(4015, 'A. Gonzales Chaves', 105),\
(4016, 'Aguas Verdes', 105),\
(4017, 'Alberti', 105),\
(4018, 'Arrecifes', 105),\
(4019, 'Ayacucho', 105),\
(4020, 'Azul', 105),\
(4021, 'Area Reserva Cinturon Ecologico', 105),\
(4022, 'Avellaneda', 105),\
(4023, 'Bahia Blanca', 105),\
(4024, 'Balcarce', 105),\
(4025, 'Baradero', 105),\
(4026, 'Banfield', 105),\
(4027, 'Barrio Parque', 105),\
(4028, 'Barrio Santa Teresita', 105),\
(4029, 'Benito Juarez', 105),\
(4030, 'Berisso', 105),\
(4031, 'Beccar', 105),\
(4032, 'Bella Vista', 105),\
(4033, 'Berazategui', 105),\
(4034, 'Bernal Este', 105),\
(4035, 'Bernal Oeste', 105),\
(4036, 'Billinghurst', 105),\
(4037, 'Bolivar', 105),\
(4038, 'Boulogne', 105),\
(4039, 'Bragado', 105),\
(4040, 'Brandsen', 105),\
(4041, 'Burzaco', 105),\
(4042, 'Caseros', 105),\
(4043, 'Castelar', 105),\
(4044, 'Churruca', 105),\
(4045, 'Ciudad Evita', 105),\
(4046, 'Ciudad Madero', 105),\
(4047, 'Ciudadela', 105),\
(4048, 'Claypole', 105),\
(4049, 'Crucecita', 105),\
(4050, 'Campana', 105),\
(4051, 'Caniuelas', 105),\
(4052, 'Capilla del Senior', 105),\
(4053, 'Capitan Sarmiento', 105),\
(4054, 'Carapachay', 105),\
(4055, 'Carhue', 105),\
(4056, 'Carilo', 105),\
(4057, 'Carlos Casares', 105),\
(4058, 'Carlos Tejedor', 105),\
(4059, 'Carmen de Areco', 105),\
(4060, 'Carmen de Patagones', 105),\
(4061, 'Castelli', 105),\
(4062, 'Chacabuco', 105),\
(4063, 'Chascomus', 105),\
(4064, 'Chivilcoy', 105),\
(4065, 'Colon', 105),\
(4066, 'Coronel Dorrego', 105),\
(4067, 'Coronel Pringles', 105),\
(4068, 'Coronel Rosales', 105),\
(4069, 'Coronel Suarez', 105),\
(4070, 'Costa Azul', 105),\
(4071, 'Costa Chica', 105),\
(4072, 'Costa del Este', 105),\
(4073, 'Costa Esmeralda', 105),\
(4074, 'Daireaux', 105),\
(4075, 'Darregueira', 105),\
(4076, 'Del Viso', 105),\
(4077, 'Dolores', 105),\
(4078, 'Don Torcuato', 105),\
(4079, 'Dock Sud', 105),\
(4080, 'Don Bosco', 105),\
(4081, 'Don Orione', 105),\
(4082, 'Ensenada', 105),\
(4083, 'Escobar', 105),\
(4084, 'El Jaguel', 105),\
(4085, 'El Libertador', 105),\
(4086, 'El Palomar', 105),\
(4087, 'El Tala', 105),\
(4088, 'El Trebol', 105),\
(4089, 'Ezeiza', 105),\
(4090, 'Ezpeleta', 105),\
(4091, 'Exaltacion de la Cruz', 105),\
(4092, 'Florentino Ameghino', 105),\
(4093, 'Florencio Varela', 105),\
(4094, 'Florida', 105),\
(4095, 'Francisco alvarez', 105),\
(4096, 'Garin', 105),\
(4097, 'Gral. Alvarado', 105),\
(4098, 'Gral. Alvear', 105),\
(4099, 'Gral. Arenales', 105),\
(4100, 'Gral. Belgrano', 105),\
(4101, 'Gral. Guido', 105),\
(4102, 'Gral. Lamadrid', 105),\
(4103, 'Gral. Las Heras', 105),\
(4104, 'Gral. Lavalle', 105),\
(4105, 'Gral. Madariaga', 105),\
(4106, 'Gral. Pacheco', 105),\
(4107, 'Gral. Paz', 105),\
(4108, 'Gral. Pinto', 105),\
(4109, 'Gral. Pueyrredon', 105),\
(4110, 'Gral. Rodriguez', 105),\
(4111, 'Gral. Viamonte', 105),\
(4112, 'Gral. Villegas', 105),\
(4113, 'Guamini', 105),\
(4114, 'Guernica', 105),\
(4115, 'Gerli', 105),\
(4116, 'Glew', 105),\
(4117, 'Gonzalez Catan', 105),\
(4118, 'Grand Bourg', 105),\
(4119, 'Gregorio de Laferrere', 105),\
(4120, 'Guillermo Enrique Hudson', 105),\
(4121, 'Haedo', 105),\
(4122, 'Hipolito Yrigoyen', 105),\
(4123, 'Hurlingham', 105),\
(4124, 'Ing. Sourdeaux', 105),\
(4125, 'Isidro Casanova', 105),\
(4126, 'Ituzaingo', 105),\
(4127, 'Ing. Maschwitz', 105),\
(4128, 'Jose C. Paz', 105),\
(4129, 'Jose Ingenieros', 105),\
(4130, 'Jose Marmol', 105),\
(4131, 'Junin', 105),\
(4132, 'La Plata', 105),\
(4133, 'La Lucila', 105),\
(4134, 'La Reja', 105),\
(4135, 'La Tablada', 105),\
(4136, 'Laprida', 105),\
(4137, 'Las Flores', 105),\
(4138, 'Las Toninas', 105),\
(4139, 'Lanus', 105),\
(4140, 'Leandro N. Alem', 105),\
(4141, 'Lincoln', 105),\
(4142, 'Loberia', 105),\
(4143, 'Lobos', 105),\
(4144, 'Los Cardales', 105),\
(4145, 'Los Toldos', 105),\
(4146, 'Lucila del Mar', 105),\
(4147, 'Lujan', 105),\
(4148, 'Llavallol', 105),\
(4149, 'Loma Hermosa', 105),\
(4150, 'Lomas de Zamora', 105),\
(4151, 'Lomas del Millon', 105),\
(4152, 'Lomas del Mirador', 105),\
(4153, 'Longchamps', 105),\
(4154, 'Los Polvorines', 105),\
(4155, 'Luis Guillon', 105),\
(4156, 'Malvinas Argentinas', 105),\
(4157, 'Martin Coronado', 105),\
(4158, 'Martinez', 105),\
(4159, 'Merlo', 105),\
(4160, 'Ministro Rivadavia', 105),\
(4161, 'Monte Chingolo', 105),\
(4162, 'Monte Grande', 105),\
(4163, 'Moreno', 105),\
(4164, 'Moron', 105),\
(4165, 'Muniiz', 105),\
(4166, 'Magdalena', 105),\
(4167, 'Maipu', 105),\
(4168, 'Mar Chiquita', 105),\
(4169, 'Mar de Ajo', 105),\
(4170, 'Mar de las Pampas', 105),\
(4171, 'Mar del Plata', 105),\
(4172, 'Mar del Tuyu', 105),\
(4173, 'Marcos Paz', 105),\
(4174, 'Mercedes', 105),\
(4175, 'Miramar', 105),\
(4176, 'Monte', 105),\
(4177, 'Monte Hermoso', 105),\
(4178, 'Munro', 105),\
(4179, 'Navarro', 105),\
(4180, 'Necochea', 105),\
(4181, 'Olavarria', 105),\
(4182, 'Olivos', 105),\
(4183, 'Pablo Nogues', 105),\
(4184, 'Pablo Podesta', 105),\
(4185, 'Paso del Rey', 105),\
(4186, 'Pereyra', 105),\
(4187, 'Pinieiro', 105),\
(4188, 'Platanos', 105),\
(4189, 'Partido de la Costa', 105),\
(4190, 'Pehuajo', 105),\
(4191, 'Pellegrini', 105),\
(4192, 'Pergamino', 105),\
(4193, 'Pigue', 105),\
(4194, 'Pila', 105),\
(4195, 'Pilar', 105),\
(4196, 'Pinamar', 105),\
(4197, 'Pinar del Sol', 105),\
(4198, 'Polvorines', 105),\
(4199, 'Pontevedra', 105),\
(4200, 'Pte. Peron', 105),\
(4201, 'Puan', 105),\
(4202, 'Punta Indio', 105),\
(4203, 'Quilmes', 105),\
(4204, 'Ramallo', 105),\
(4205, 'Rafael Calzada', 105),\
(4206, 'Rafael Castillo', 105),\
(4207, 'Ramos Mejia', 105),\
(4208, 'Ranelagh', 105),\
(4209, 'Remedios de Escalada', 105),\
(4210, 'Rauch', 105),\
(4211, 'Rivadavia', 105),\
(4212, 'Rojas', 105),\
(4213, 'Roque Perez', 105),\
(4214, 'Saavedra', 105),\
(4215, 'Saladillo', 105),\
(4216, 'Salliquelo', 105),\
(4217, 'Salto', 105),\
(4218, 'Saenz Penia', 105),\
(4219, 'Santos Lugares', 105),\
(4220, 'Sarandi', 105),\
(4221, 'Sourigues', 105),\
(4222, 'San Andres de Giles', 105),\
(4223, 'San Antonio de Areco', 105),\
(4224, 'San Antonio de Padua', 105),\
(4225, 'San Bernardo', 105),\
(4226, 'San Cayetano', 105),\
(4227, 'San Clemente del Tuyu', 105),\
(4228, 'San Nicolas', 105),\
(4229, 'San Pedro', 105),\
(4230, 'San Vicente', 105),\
(4231, 'San Fernando', 105),\
(4232, 'San Francisco Solano', 105),\
(4233, 'San Isidro', 105),\
(4234, 'San Jose', 105),\
(4235, 'San Justo', 105),\
(4236, 'San Martin', 105),\
(4237, 'San Miguel', 105),\
(4238, 'Santa Teresita', 105),\
(4239, 'Suipacha', 105),\
(4240, 'Tandil', 105),\
(4241, 'Tapalque', 105),\
(4242, 'Tapiales', 105),\
(4243, 'Temperley', 105),\
(4244, 'Tigre', 105),\
(4245, 'Tortuguitas', 105),\
(4246, 'Tristan Suarez', 105),\
(4247, 'Trujui', 105),\
(4248, 'Tordillo', 105),\
(4249, 'Tornquist', 105),\
(4250, 'Trenque Lauquen', 105),\
(4251, 'Tres Lomas', 105),\
(4252, 'Turdera', 105),\
(4253, 'Valentin Alsina', 105),\
(4254, 'Vicente Lopez', 105),\
(4255, 'Villa Adelina', 105),\
(4256, 'Villa Ballester', 105),\
(4257, 'Villa Bosch', 105),\
(4258, 'Villa Caraza', 105),\
(4259, 'Villa Celina', 105),\
(4260, 'Villa Centenario', 105),\
(4261, 'Villa de Mayo', 105),\
(4262, 'Villa Diamante', 105),\
(4263, 'Villa Dominico', 105),\
(4264, 'Villa Espania', 105),\
(4265, 'Villa Fiorito', 105),\
(4266, 'Villa Guillermina', 105),\
(4267, 'Villa Gesell', 105),\
(4268, 'Villa Insuperable', 105),\
(4269, 'Villa Jose Leon Suarez', 105),\
(4270, 'Villa La Florida', 105),\
(4271, 'Villa Luzuriaga', 105),\
(4272, 'Villa Martelli', 105),\
(4273, 'Villa Obrera', 105),\
(4274, 'Villa Progreso', 105),\
(4275, 'Villa Raffo', 105),\
(4276, 'Villa Sarmiento', 105),\
(4277, 'Villa Tesei', 105),\
(4278, 'Villa Udaondo', 105),\
(4279, 'Villarino', 105),\
(4280, 'Virrey del Pino', 105),\
(4281, 'Wilde', 105),\
(4282, 'William Morris', 105),\
(4283, 'Zarate', 105),\
(4284, 'Alto Pelado', 106),\
(4285, 'Alto Pencoso', 106),\
(4286, 'Anchorena', 106),\
(4287, 'Arizona', 106),\
(4288, 'Bagual', 106),\
(4289, 'Balde', 106),\
(4290, 'Batavia', 106),\
(4291, 'Beazley', 106),\
(4292, 'Buena Esperanza', 106),\
(4293, 'Candelaria', 106),\
(4294, 'Capital', 106),\
(4295, 'Carolina', 106),\
(4296, 'Carpinteria', 106),\
(4297, 'Concaran', 106),\
(4298, 'Cortaderas', 106),\
(4299, 'El Morro', 106),\
(4300, 'El Trapiche', 106),\
(4301, 'El Volcan', 106),\
(4302, 'Fortin El Patria', 106),\
(4303, 'Fortuna', 106),\
(4304, 'Fraga', 106),\
(4305, 'Juan Jorba', 106),\
(4306, 'Juan Llerena', 106),\
(4307, 'Juana Koslay', 106),\
(4308, 'Justo Daract', 106),\
(4309, 'La Calera', 106),\
(4310, 'La Florida', 106),\
(4311, 'La Punilla', 106),\
(4312, 'La Toma', 106),\
(4313, 'Lafinur', 106),\
(4314, 'Las Aguadas', 106),\
(4315, 'Las Chacras', 106),\
(4316, 'Las Lagunas', 106),\
(4317, 'Las Vertientes', 106),\
(4318, 'Lavaisse', 106),\
(4319, 'Leandro N. Alem', 106),\
(4320, 'Los Molles', 106),\
(4321, 'Lujan', 106),\
(4322, 'Mercedes', 106),\
(4323, 'Merlo', 106),\
(4324, 'Naschel', 106),\
(4325, 'Navia', 106),\
(4326, 'Nogoli', 106),\
(4327, 'Nueva Galia', 106),\
(4328, 'Papagayos', 106),\
(4329, 'Paso Grande', 106),\
(4330, 'Potrero de Los Funes', 106),\
(4331, 'Quines', 106),\
(4332, 'Renca', 106),\
(4333, 'Saladillo', 106),\
(4334, 'San Francisco', 106),\
(4335, 'San Geronimo', 106),\
(4336, 'San Martin', 106),\
(4337, 'San Pablo', 106),\
(4338, 'Santa Rosa de Conlara', 106),\
(4339, 'Talita', 106),\
(4340, 'Tilisarao', 106),\
(4341, 'Union', 106),\
(4342, 'Villa de La Quebrada', 106),\
(4343, 'Villa de Praga', 106),\
(4344, 'Villa del Carmen', 106),\
(4345, 'Villa Gral. Roca', 106),\
(4346, 'Villa Larca', 106),\
(4347, 'Villa Mercedes', 106),\
(4348, 'Zanjitas', 106),\
(4349, 'Alarcon', 107),\
(4350, 'Alcaraz', 107),\
(4351, 'Alcaraz N.', 107),\
(4352, 'Alcaraz S.', 107),\
(4353, 'Aldea Asuncion', 107),\
(4354, 'Aldea Brasilera', 107),\
(4355, 'Aldea Elgenfeld', 107),\
(4356, 'Aldea Grapschental', 107),\
(4357, 'Aldea Ma. Luisa', 107),\
(4358, 'Aldea Protestante', 107),\
(4359, 'Aldea Salto', 107),\
(4360, 'Aldea San Antonio G', 107),\
(4361, 'Aldea San Antonio P', 107),\
(4362, 'Aldea San Juan', 107),\
(4363, 'Aldea San Miguel', 107),\
(4364, 'Aldea San Rafael', 107),\
(4365, 'Aldea Spatzenkutter', 107),\
(4366, 'Aldea Sta. Maria', 107),\
(4367, 'Aldea Sta. Rosa', 107),\
(4368, 'Aldea Valle Maria', 107),\
(4369, 'Altamirano Sur', 107),\
(4370, 'Antelo', 107),\
(4371, 'Antonio Tomas', 107),\
(4372, 'Aranguren', 107),\
(4373, 'Arroyo Baru', 107),\
(4374, 'Arroyo Burgos', 107),\
(4375, 'Arroyo Cle', 107),\
(4376, 'Arroyo Corralito', 107),\
(4377, 'Arroyo del Medio', 107),\
(4378, 'Arroyo Maturrango', 107),\
(4379, 'Arroyo Palo Seco', 107),\
(4380, 'Banderas', 107),\
(4381, 'Basavilbaso', 107),\
(4382, 'Betbeder', 107),\
(4383, 'Bovril', 107),\
(4384, 'Caseros', 107),\
(4385, 'Ceibas', 107),\
(4386, 'Cerrito', 107),\
(4387, 'Chajari', 107),\
(4388, 'Chilcas', 107),\
(4389, 'Clodomiro Ledesma', 107),\
(4390, 'Col. Alemana', 107),\
(4391, 'Col. Avellaneda', 107),\
(4392, 'Col. Avigdor', 107),\
(4393, 'Col. Ayui', 107),\
(4394, 'Col. Baylina', 107),\
(4395, 'Col. Carrasco', 107),\
(4396, 'Col. Celina', 107),\
(4397, 'Col. Cerrito', 107),\
(4398, 'Col. Crespo', 107),\
(4399, 'Col. Elia', 107),\
(4400, 'Col. Ensayo', 107),\
(4401, 'Col. Gral. Roca', 107),\
(4402, 'Col. La Argentina', 107),\
(4403, 'Col. Merou', 107),\
(4404, 'Col. Oficial Nf3', 107),\
(4405, 'Col. Oficial N 13', 107),\
(4406, 'Col. Oficial N 14', 107),\
(4407, 'Col. Oficial N5', 107),\
(4408, 'Col. Reffino', 107),\
(4409, 'Col. Tunas', 107),\
(4410, 'Col. Viraro', 107),\
(4411, 'Colon', 107),\
(4412, 'Concepcion del Uruguay', 107),\
(4413, 'Concordia', 107),\
(4414, 'Conscripto Bernardi', 107),\
(4415, 'Costa Grande', 107),\
(4416, 'Costa San Antonio', 107),\
(4417, 'Costa Uruguay N.', 107),\
(4418, 'Costa Uruguay S.', 107),\
(4419, 'Crespo', 107),\
(4420, 'Crucecitas 3', 107),\
(4421, 'Crucecitas 7', 107),\
(4422, 'Crucecitas 8', 107),\
(4423, 'Cuchilla Redonda', 107),\
(4424, 'Curtiembre', 107),\
(4425, 'Diamante', 107),\
(4426, 'Distrito 6', 107),\
(4427, 'Distrito Chaniar', 107),\
(4428, 'Distrito Chiqueros', 107),\
(4429, 'Distrito Cuarto', 107),\
(4430, 'Distrito Diego Lopez', 107),\
(4431, 'Distrito Pajonal', 107),\
(4432, 'Distrito Sauce', 107),\
(4433, 'Distrito Tala', 107),\
(4434, 'Distrito Talitas', 107),\
(4435, 'Don Cristobal 1 Seccion', 107),\
(4436, 'Don Cristobal 2 Seccion', 107),\
(4437, 'Durazno', 107),\
(4438, 'El Cimarron', 107),\
(4439, 'El Gramillal', 107),\
(4440, 'El Palenque', 107),\
(4441, 'El Pingo', 107),\
(4442, 'El Quebracho', 107),\
(4443, 'El Redomon', 107),\
(4444, 'El Solar', 107),\
(4445, 'Enrique Carbo', 107),\
(4446, 'Entre Rios', 107),\
(4447, 'Espinillo N.', 107),\
(4448, 'Estacion Campos', 107),\
(4449, 'Estacion Escrinia', 107),\
(4450, 'Estacion Lazo', 107),\
(4451, 'Estacion Raices', 107),\
(4452, 'Estacion Yerua', 107),\
(4453, 'Estancia Grande', 107),\
(4454, 'Estancia Libaros', 107),\
(4455, 'Estancia Racedo', 107),\
(4456, 'Estancia Sola', 107),\
(4457, 'Estancia Yuqueri', 107),\
(4458, 'Estaquitas', 107),\
(4459, 'Faustino M. Parera', 107),\
(4460, 'Febre', 107),\
(4461, 'Federacion', 107),\
(4462, 'Federal', 107),\
(4463, 'Gdor. Echague', 107),\
(4464, 'Gdor. Mansilla', 107),\
(4465, 'Gilbert', 107),\
(4466, 'Gonzalez Calderon', 107),\
(4467, 'Gral. Almada', 107),\
(4468, 'Gral. Alvear', 107),\
(4469, 'Gral. Campos', 107),\
(4470, 'Gral. Galarza', 107),\
(4471, 'Gral. Ramirez', 107),\
(4472, 'Gualeguay', 107),\
(4473, 'Gualeguaychu', 107),\
(4474, 'Gualeguaycito', 107),\
(4475, 'Guardamonte', 107),\
(4476, 'Hambis', 107),\
(4477, 'Hasenkamp', 107),\
(4478, 'Hernandarias', 107),\
(4479, 'Hernandez', 107),\
(4480, 'Herrera', 107),\
(4481, 'Hinojal', 107),\
(4482, 'Hocker', 107),\
(4483, 'Ing. Sajaroff', 107),\
(4484, 'Irazusta', 107),\
(4485, 'Isletas', 107),\
(4486, 'J.J De Urquiza', 107),\
(4487, 'Jubileo', 107),\
(4488, 'La Clarita', 107),\
(4489, 'La Criolla', 107),\
(4490, 'La Esmeralda', 107),\
(4491, 'La Florida', 107),\
(4492, 'La Fraternidad', 107),\
(4493, 'La Hierra', 107),\
(4494, 'La Ollita', 107),\
(4495, 'La Paz', 107),\
(4496, 'La Picada', 107),\
(4497, 'La Providencia', 107),\
(4498, 'La Verbena', 107),\
(4499, 'Laguna Benitez', 107),\
(4500, 'Larroque', 107),\
(4501, 'Las Cuevas', 107),\
(4502, 'Las Garzas', 107),\
(4503, 'Las Guachas', 107),\
(4504, 'Las Mercedes', 107),\
(4505, 'Las Moscas', 107),\
(4506, 'Las Mulitas', 107),\
(4507, 'Las Toscas', 107),\
(4508, 'Laurencena', 107),\
(4509, 'Libertador San Martin', 107),\
(4510, 'Loma Limpia', 107),\
(4511, 'Los Ceibos', 107),\
(4512, 'Los Charruas', 107),\
(4513, 'Los Conquistadores', 107),\
(4514, 'Lucas Gonzalez', 107),\
(4515, 'Lucas N.', 107),\
(4516, 'Lucas S. 1', 107),\
(4517, 'Lucas S. 2', 107),\
(4518, 'Macia', 107),\
(4519, 'Maria Grande', 107),\
(4520, 'Maria Grande 2', 107),\
(4521, 'Medanos', 107),\
(4522, 'Mojones N.', 107),\
(4523, 'Mojones S.', 107),\
(4524, 'Molino Doll', 107),\
(4525, 'Monte Redondo', 107),\
(4526, 'Montoya', 107),\
(4527, 'Mulas Grandes', 107),\
(4528, 'niancay', 107),\
(4529, 'Nogoya', 107),\
(4530, 'Nueva Escocia', 107),\
(4531, 'Nueva Vizcaya', 107),\
(4532, 'Ombu', 107),\
(4533, 'Oro Verde', 107),\
(4534, 'Parana', 107),\
(4535, 'Pasaje Guayaquil', 107),\
(4536, 'Pasaje Las Tunas', 107),\
(4537, 'Paso de La Arena', 107),\
(4538, 'Paso de La Laguna', 107),\
(4539, 'Paso de Las Piedras', 107),\
(4540, 'Paso Duarte', 107),\
(4541, 'Pastor Britos', 107),\
(4542, 'Pedernal', 107),\
(4543, 'Perdices', 107),\
(4544, 'Picada Beron', 107),\
(4545, 'Piedras Blancas', 107),\
(4546, 'Primer Distrito Cuchilla', 107),\
(4547, 'Primero de Mayo', 107),\
(4548, 'Pronunciamiento', 107),\
(4549, 'Pto. Algarrobo', 107),\
(4550, 'Pto. Ibicuy', 107),\
(4551, 'Pueblo Brugo', 107),\
(4552, 'Pueblo Cazes', 107),\
(4553, 'Pueblo Gral. Belgrano', 107),\
(4554, 'Pueblo Liebig', 107),\
(4555, 'Puerto Yerua', 107),\
(4556, 'Punta del Monte', 107),\
(4557, 'Quebracho', 107),\
(4558, 'Quinto Distrito', 107),\
(4559, 'Raices Oeste', 107),\
(4560, 'Rincon de Nogoya', 107),\
(4561, 'Rincon del Cinto', 107),\
(4562, 'Rincon del Doll', 107),\
(4563, 'Rincon del Gato', 107),\
(4564, 'Rocamora', 107),\
(4565, 'Rosario del Tala', 107),\
(4566, 'San Benito', 107),\
(4567, 'San Cipriano', 107),\
(4568, 'San Ernesto', 107),\
(4569, 'San Gustavo', 107),\
(4570, 'San Jaime', 107),\
(4571, 'San Jose', 107),\
(4572, 'San Jose de Feliciano', 107),\
(4573, 'San Justo', 107),\
(4574, 'San Marcial', 107),\
(4575, 'San Pedro', 107),\
(4576, 'San Ramirez', 107),\
(4577, 'San Ramon', 107),\
(4578, 'San Roque', 107),\
(4579, 'San Salvador', 107),\
(4580, 'San Victor', 107),\
(4581, 'Santa Ana', 107),\
(4582, 'Santa Anita', 107),\
(4583, 'Santa Elena', 107),\
(4584, 'Santa Lucia', 107),\
(4585, 'Santa Luisa', 107),\
(4586, 'Sauce de Luna', 107),\
(4587, 'Sauce Montrull', 107),\
(4588, 'Sauce Pinto', 107),\
(4589, 'Sauce Sur', 107),\
(4590, 'Segui', 107),\
(4591, 'Sir Leonard', 107),\
(4592, 'Sosa', 107),\
(4593, 'Tabossi', 107),\
(4594, 'Tezanos Pinto', 107),\
(4595, 'Ubajay', 107),\
(4596, 'Urdinarrain', 107),\
(4597, 'Veinte de Septiembre', 107),\
(4598, 'Viale', 107),\
(4599, 'Victoria', 107),\
(4600, 'Villa Clara', 107),\
(4601, 'Villa del Rosario', 107),\
(4602, 'Villa Dominguez', 107),\
(4603, 'Villa Elisa', 107),\
(4604, 'Villa Fontana', 107),\
(4605, 'Villa Gdor. Etchevehere', 107),\
(4606, 'Villa Mantero', 107),\
(4607, 'Villa Paranacito', 107),\
(4608, 'Villa Urquiza', 107),\
(4609, 'Villaguay', 107),\
(4610, 'Walter Moss', 107),\
(4611, 'Yacare', 107),\
(4612, 'Yeso Oeste', 107),\
(4613, 'Arauco', 108),\
(4614, 'Capital', 108),\
(4615, 'Castro Barros', 108),\
(4616, 'Chamical', 108),\
(4617, 'Chilecito', 108),\
(4618, 'Coronel F. Varela', 108),\
(4619, 'Famatina', 108),\
(4620, 'Gral. A.V.Penialoza', 108),\
(4621, 'Gral. Belgrano', 108),\
(4622, 'Gral. J.F. Quiroga', 108),\
(4623, 'Gral. Lamadrid', 108),\
(4624, 'Gral. Ocampo', 108),\
(4625, 'Gral. San Martin', 108),\
(4626, 'Independencia', 108),\
(4627, 'Rosario Penaloza', 108),\
(4628, 'San Blas de Los Sauces', 108),\
(4629, 'Sanagasta', 108),\
(4630, 'Vinchina', 108),\
(4631, 'Aniatuya', 109),\
(4632, 'Arraga', 109),\
(4633, 'Bandera', 109),\
(4634, 'Bandera Bajada', 109),\
(4635, 'Beltran', 109),\
(4636, 'Brea Pozo', 109),\
(4637, 'Campo Gallo', 109),\
(4638, 'Capital', 109),\
(4639, 'Chilca Juliana', 109),\
(4640, 'Choya', 109),\
(4641, 'Clodomira', 109),\
(4642, 'Col. Alpina', 109),\
(4643, 'Col. Dora', 109),\
(4644, 'Col. El Simbolar Robles', 109),\
(4645, 'El Bobadal', 109),\
(4646, 'El Charco', 109),\
(4647, 'El Mojon', 109),\
(4648, 'Estacion Atamisqui', 109),\
(4649, 'Estacion Simbolar', 109),\
(4650, 'Fernandez', 109),\
(4651, 'Fortin Inca', 109),\
(4652, 'Frias', 109),\
(4653, 'Garza', 109),\
(4654, 'Gramilla', 109),\
(4655, 'Guardia Escolta', 109),\
(4656, 'Herrera', 109),\
(4657, 'Icanio', 109),\
(4658, 'Ing. Forres', 109),\
(4659, 'La Banda', 109),\
(4660, 'La Caniada', 109),\
(4661, 'Laprida', 109),\
(4662, 'Lavalle', 109),\
(4663, 'Loreto', 109),\
(4664, 'Los Juries', 109),\
(4665, 'Los Nuniez', 109),\
(4666, 'Los Pirpintos', 109),\
(4667, 'Los Quiroga', 109),\
(4668, 'Los Telares', 109),\
(4669, 'Lugones', 109),\
(4670, 'Malbran', 109),\
(4671, 'Matara', 109),\
(4672, 'Medellin', 109),\
(4673, 'Monte Quemado', 109),\
(4674, 'Nueva Esperanza', 109),\
(4675, 'Nueva Francia', 109),\
(4676, 'Palo Negro', 109),\
(4677, 'Pampa de Los Guanacos', 109),\
(4678, 'Pinto', 109),\
(4679, 'Pozo Hondo', 109),\
(4680, 'Quimili', 109),\
(4681, 'Real Sayana', 109),\
(4682, 'Sachayoj', 109),\
(4683, 'San Pedro de Guasayan', 109),\
(4684, 'Selva', 109),\
(4685, 'Sol de Julio', 109),\
(4686, 'Sumampa', 109),\
(4687, 'Suncho Corral', 109),\
(4688, 'Taboada', 109),\
(4689, 'Tapso', 109),\
(4690, 'Termas de Rio Hondo', 109),\
(4691, 'Tintina', 109),\
(4692, 'Tomas Young', 109),\
(4693, 'Vilelas', 109),\
(4694, 'Villa Atamisqui', 109),\
(4695, 'Villa La Punta', 109),\
(4696, 'Villa Ojo de Agua', 109),\
(4697, 'Villa Rio Hondo', 109),\
(4698, 'Villa Salavina', 109),\
(4699, 'Villa Union', 109),\
(4700, 'Vilmer', 109),\
(4701, 'Weisburd', 109),\
(4702, 'Avia Terai', 110),\
(4703, 'Barranqueras', 110),\
(4704, 'Basail', 110),\
(4705, 'Campo Largo', 110),\
(4706, 'Capital', 110),\
(4707, 'Capitan Solari', 110),\
(4708, 'Charadai', 110),\
(4709, 'Charata', 110),\
(4710, 'Chorotis', 110),\
(4711, 'Ciervo Petiso', 110),\
(4712, 'Cnel. Du Graty', 110),\
(4713, 'Col. Benitez', 110),\
(4714, 'Col. Elisa', 110),\
(4715, 'Col. Popular', 110),\
(4716, 'Colonias Unidas', 110),\
(4717, 'Concepcion', 110),\
(4718, 'Corzuela', 110),\
(4719, 'Cote Lai', 110),\
(4720, 'El Sauzalito', 110),\
(4721, 'Enrique Urien', 110),\
(4722, 'Fontana', 110),\
(4723, 'Fte. Esperanza', 110),\
(4724, 'Gancedo', 110),\
(4725, 'Gral. Capdevila', 110),\
(4726, 'Gral. Pinero', 110),\
(4727, 'Gral. San Martin', 110),\
(4728, 'Gral. Vedia', 110),\
(4729, 'Hermoso Campo', 110),\
(4730, 'I. del Cerrito', 110),\
(4731, 'J.J. Castelli', 110),\
(4732, 'La Clotilde', 110),\
(4733, 'La Eduvigis', 110),\
(4734, 'La Escondida', 110),\
(4735, 'La Leonesa', 110),\
(4736, 'La Tigra', 110),\
(4737, 'La Verde', 110),\
(4738, 'Laguna Blanca', 110),\
(4739, 'Laguna Limpia', 110),\
(4740, 'Lapachito', 110),\
(4741, 'Las Brenias', 110),\
(4742, 'Las Garcitas', 110),\
(4743, 'Las Palmas', 110),\
(4744, 'Los Frentones', 110),\
(4745, 'Machagai', 110),\
(4746, 'Makalle', 110),\
(4747, 'Margarita Belen', 110),\
(4748, 'Miraflores', 110),\
(4749, 'Mision N. Pompeya', 110),\
(4750, 'Napenay', 110),\
(4751, 'Pampa Almiron', 110),\
(4752, 'Pampa del Indio', 110),\
(4753, 'Pampa del Infierno', 110),\
(4754, 'Pdcia. de La Plaza', 110),\
(4755, 'Pdcia. Roca', 110),\
(4756, 'Pdcia. Roque Saenz Penia', 110),\
(4757, 'Pto. Bermejo', 110),\
(4758, 'Pto. Eva Peron', 110),\
(4759, 'Puero Tirol', 110),\
(4760, 'Puerto Vilelas', 110),\
(4761, 'Quitilipi', 110),\
(4762, 'Resistencia', 110),\
(4763, 'Saenz Penia', 110),\
(4764, 'Samuhu', 110),\
(4765, 'San Bernardo', 110),\
(4766, 'Santa Sylvina', 110),\
(4767, 'Taco Pozo', 110),\
(4768, 'Tres Isletas', 110),\
(4769, 'Villa angela', 110),\
(4770, 'Villa Berthet', 110),\
(4771, 'Villa R. Bermejito', 110),\
(4772, 'Albardon', 111),\
(4773, 'Angaco', 111),\
(4774, 'Calingasta', 111),\
(4775, 'Capital', 111),\
(4776, 'Caucete', 111),\
(4777, 'Chimbas', 111),\
(4778, 'Iglesia', 111),\
(4779, 'Jachal', 111),\
(4780, 'Nueve de Julio', 111),\
(4781, 'Pocito', 111),\
(4782, 'Rawson', 111),\
(4783, 'Rivadavia', 111),\
(4784, 'San Juan', 111),\
(4785, 'San Martin', 111),\
(4786, 'Santa Lucia', 111),\
(4787, 'Sarmiento', 111),\
(4788, 'Ullum', 111),\
(4789, 'Valle Fertil', 111),\
(4790, 'Veinticinco de Mayo', 111),\
(4791, 'Zonda', 111),\
(4792, 'Aconquija', 112),\
(4793, 'Ancasti', 112),\
(4794, 'Andalgala', 112),\
(4795, 'Antofagasta', 112),\
(4796, 'Belen', 112),\
(4797, 'Capayan', 112),\
(4798, 'Capital', 112),\
(4799, 'Catamarca', 112),\
(4800, 'Corral Quemado', 112),\
(4801, 'El Alto', 112),\
(4802, 'El Rodeo', 112),\
(4803, 'F.Mamerto Esquiu', 112),\
(4804, 'Fiambala', 112),\
(4805, 'Hualfin', 112),\
(4806, 'Huillapima', 112),\
(4807, 'Icanio', 112),\
(4808, 'La Puerta', 112),\
(4809, 'Las Juntas', 112),\
(4810, 'Londres', 112),\
(4811, 'Los Altos', 112),\
(4812, 'Los Varela', 112),\
(4813, 'Mutquin', 112),\
(4814, 'Paclin', 112),\
(4815, 'Poman', 112),\
(4816, 'Pozo de La Piedra', 112),\
(4817, 'Puerta de Corral', 112),\
(4818, 'Puerta San Jose', 112),\
(4819, 'Recreo', 112),\
(4820, 'S.F.V de Catamarca', 112),\
(4821, 'San Fernando', 112),\
(4822, 'San Fernando del Valle', 112),\
(4823, 'San Jose', 112),\
(4824, 'Santa Maria', 112),\
(4825, 'Santa Rosa', 112),\
(4826, 'Saujil', 112),\
(4827, 'Tapso', 112),\
(4828, 'Tinogasta', 112),\
(4829, 'Valle Viejo', 112),\
(4830, 'Villa Vil', 112),\
(4831, 'Abramo', 113),\
(4832, 'Adolfo Van Praet', 113),\
(4833, 'Agustoni', 113),\
(4834, 'Algarrobo del Aguila', 113),\
(4835, 'Alpachiri', 113),\
(4836, 'Alta Italia', 113),\
(4837, 'Anguil', 113),\
(4838, 'Arata', 113),\
(4839, 'Ataliva Roca', 113),\
(4840, 'Bernardo Larroude', 113),\
(4841, 'Bernasconi', 113),\
(4842, 'Caleufu', 113),\
(4843, 'Carro Quemado', 113),\
(4844, 'Catrilo', 113),\
(4845, 'Ceballos', 113),\
(4846, 'Chacharramendi', 113),\
(4847, 'Col. Baron', 113),\
(4848, 'Col. Santa Maria', 113),\
(4849, 'Conhelo', 113),\
(4850, 'Coronel Hilario Lagos', 113),\
(4851, 'Cuchillo-Co', 113),\
(4852, 'Doblas', 113),\
(4853, 'Dorila', 113),\
(4854, 'Eduardo Castex', 113),\
(4855, 'Embajador Martini', 113),\
(4856, 'Falucho', 113),\
(4857, 'Gral. Acha', 113),\
(4858, 'Gral. Manuel Campos', 113),\
(4859, 'Gral. Pico', 113),\
(4860, 'Guatrache', 113),\
(4861, 'Ing. Luiggi', 113),\
(4862, 'Intendente Alvear', 113),\
(4863, 'Jacinto Arauz', 113),\
(4864, 'La Adela', 113),\
(4865, 'La Humada', 113),\
(4866, 'La Maruja', 113),\
(4867, 'La Pampa', 113),\
(4868, 'La Reforma', 113),\
(4869, 'Limay Mahuida', 113),\
(4870, 'Lonquimay', 113),\
(4871, 'Loventuel', 113),\
(4872, 'Luan Toro', 113),\
(4873, 'Macachin', 113),\
(4874, 'Maisonnave', 113),\
(4875, 'Mauricio Mayer', 113),\
(4876, 'Metileo', 113),\
(4877, 'Miguel Cane', 113),\
(4878, 'Miguel Riglos', 113),\
(4879, 'Monte Nievas', 113),\
(4880, 'Parera', 113),\
(4881, 'Peru', 113),\
(4882, 'Pichi-Huinca', 113),\
(4883, 'Puelches', 113),\
(4884, 'Puelen', 113),\
(4885, 'Quehue', 113),\
(4886, 'Quemu Quemu', 113),\
(4887, 'Quetrequen', 113),\
(4888, 'Rancul', 113),\
(4889, 'Realico', 113),\
(4890, 'Relmo', 113),\
(4891, 'Rolon', 113),\
(4892, 'Rucanelo', 113),\
(4893, 'Sarah', 113),\
(4894, 'Speluzzi', 113),\
(4895, 'Sta. Isabel', 113),\
(4896, 'Sta. Rosa', 113),\
(4897, 'Sta. Teresa', 113),\
(4898, 'Telen', 113),\
(4899, 'Toay', 113),\
(4900, 'Tomas M. de Anchorena', 113),\
(4901, 'Trenel', 113),\
(4902, 'Unanue', 113),\
(4903, 'Uriburu', 113),\
(4904, 'Veinticinco de Mayo', 113),\
(4905, 'Vertiz', 113),\
(4906, 'Victorica', 113),\
(4907, 'Villa Mirasol', 113),\
(4908, 'Winifreda', 113),\
(4909, 'Capital', 114),\
(4910, 'Chacras de Coria', 114),\
(4911, 'Dorrego', 114),\
(4912, 'Gllen', 114),\
(4913, 'Godoy Cruz', 114),\
(4914, 'Gral. Alvear', 114),\
(4915, 'Guaymallen', 114),\
(4916, 'Junin', 114),\
(4917, 'La Paz', 114),\
(4918, 'Las Heras', 114),\
(4919, 'Lavalle', 114),\
(4920, 'Lujan', 114),\
(4921, 'Lujan De Cuyo', 114),\
(4922, 'Maipu', 114),\
(4923, 'Malargue', 114),\
(4924, 'Rivadavia', 114),\
(4925, 'San Carlos', 114),\
(4926, 'San Martin', 114),\
(4927, 'San Rafael', 114),\
(4928, 'Sta. Rosa', 114),\
(4929, 'Tunuyan', 114),\
(4930, 'Tupungato', 114),\
(4931, 'Villa Nueva', 114),\
(4932, 'Alba Posse', 115),\
(4933, 'Almafuerte', 115),\
(4934, 'Apostoles', 115),\
(4935, 'Aristobulo Del Valle', 115),\
(4936, 'Arroyo Del Medio', 115),\
(4937, 'Azara', 115),\
(4938, 'Bdo. De Irigoyen', 115),\
(4939, 'Bonpland', 115),\
(4940, 'Caa Yari', 115),\
(4941, 'Campo Grande', 115),\
(4942, 'Campo Ramon', 115),\
(4943, 'Campo Viera', 115),\
(4944, 'Candelaria', 115),\
(4945, 'Capiovi', 115),\
(4946, 'Caraguatay', 115),\
(4947, 'Cdte. Guacurari', 115),\
(4948, 'Cerro Azul', 115),\
(4949, 'Cerro Cora', 115),\
(4950, 'Col. Alberdi', 115),\
(4951, 'Col. Aurora', 115),\
(4952, 'Col. Delicia', 115),\
(4953, 'Col. Polana', 115),\
(4954, 'Col. Victoria', 115),\
(4955, 'Col. Wanda', 115),\
(4956, 'Concepcion De La Sierra', 115),\
(4957, 'Corpus', 115),\
(4958, 'Dos Arroyos', 115),\
(4959, 'Dos de Mayo', 115),\
(4960, 'El Alcazar', 115),\
(4961, 'El Dorado', 115),\
(4962, 'El Soberbio', 115),\
(4963, 'Esperanza', 115),\
(4964, 'F. Ameghino', 115),\
(4965, 'Fachinal', 115),\
(4966, 'Garuhape', 115),\
(4967, 'Garupa', 115),\
(4968, 'Gdor. Lopez', 115),\
(4969, 'Gdor. Roca', 115),\
(4970, 'Gral. Alvear', 115),\
(4971, 'Gral. Urquiza', 115),\
(4972, 'Guarani', 115),\
(4973, 'H. Yrigoyen', 115),\
(4974, 'Iguazu', 115),\
(4975, 'Itacaruare', 115),\
(4976, 'Jardin America', 115),\
(4977, 'Leandro N. Alem', 115),\
(4978, 'Libertad', 115),\
(4979, 'Loreto', 115),\
(4980, 'Los Helechos', 115),\
(4981, 'Martires', 115),\
(4982, 'Misiones', 115),\
(4983, 'Mojon Grande', 115),\
(4984, 'Montecarlo', 115),\
(4985, 'Nueve de Julio', 115),\
(4986, 'Obera', 115),\
(4987, 'Olegario V. Andrade', 115),\
(4988, 'Panambi', 115),\
(4989, 'Posadas', 115),\
(4990, 'Profundidad', 115),\
(4991, 'Pto. Iguazu', 115),\
(4992, 'Pto. Leoni', 115),\
(4993, 'Pto. Piray', 115),\
(4994, 'Pto. Rico', 115),\
(4995, 'Ruiz de Montoya', 115),\
(4996, 'San Antonio', 115),\
(4997, 'San Ignacio', 115),\
(4998, 'San Javier', 115),\
(4999, 'San Jose', 115),\
(5000, 'San Martin', 115),\
(5001, 'San Pedro', 115),\
(5002, 'San Vicente', 115),\
(5003, 'Santiago De Liniers', 115),\
(5004, 'Santo Pipo', 115),\
(5005, 'Sta. Ana', 115),\
(5006, 'Sta. Maria', 115),\
(5007, 'Tres Capones', 115),\
(5008, 'Veinticinco de Mayo', 115),\
(5009, 'Buena Vista', 116),\
(5010, 'Clorinda', 116),\
(5011, 'Col. Pastoril', 116),\
(5012, 'Cte. Fontana', 116),\
(5013, 'El Colorado', 116),\
(5014, 'El Espinillo', 116),\
(5015, 'Estanislao Del Campo', 116),\
(5016, 'Formosa', 116),\
(5017, 'Fortin Lugones', 116),\
(5018, 'Gral. Lucio V. Mansilla', 116),\
(5019, 'Gral. Manuel Belgrano', 116),\
(5020, 'Gral. Mosconi', 116),\
(5021, 'Gran Guardia', 116),\
(5022, 'Herradura', 116),\
(5023, 'Ibarreta', 116),\
(5024, 'Ing. Juarez', 116),\
(5025, 'Laguna Blanca', 116),\
(5026, 'Laguna Naick Neck', 116),\
(5027, 'Laguna Yema', 116),\
(5028, 'Las Lomitas', 116),\
(5029, 'Los Chiriguanos', 116),\
(5030, 'Mayor V. Villafanie', 116),\
(5031, 'Mision San Fco.', 116),\
(5032, 'Palo Santo', 116),\
(5033, 'Pirane', 116),\
(5034, 'Pozo del Maza', 116),\
(5035, 'Riacho He-He', 116),\
(5036, 'San Hilario', 116),\
(5037, 'San Martin II', 116),\
(5038, 'Siete Palmas', 116),\
(5039, 'Subteniente Perin', 116),\
(5040, 'Tres Lagunas', 116),\
(5041, 'Villa Dos Trece', 116),\
(5042, 'Villa Escolar', 116),\
(5043, 'Villa Gral. Guemes', 116),\
(5044, 'Aguada San Roque', 117),\
(5045, 'Alumine', 117),\
(5046, 'Andacollo', 117),\
(5047, 'Anielo', 117),\
(5048, 'Bajada del Agrio', 117),\
(5049, 'Barrancas', 117),\
(5050, 'Buta Ranquil', 117),\
(5051, 'Capital', 117),\
(5052, 'Caviahue', 117),\
(5053, 'Centenario', 117),\
(5054, 'Chorriaca', 117),\
(5055, 'Chos Malal', 117),\
(5056, 'Cipolletti', 117),\
(5057, 'Covunco Abajo', 117),\
(5058, 'Coyuco Cochico', 117),\
(5059, 'Cutral Co', 117),\
(5060, 'El Cholar', 117),\
(5061, 'El Huecu', 117),\
(5062, 'El Sauce', 117),\
(5063, 'Guaniacos', 117),\
(5064, 'Huinganco', 117),\
(5065, 'Las Coloradas', 117),\
(5066, 'Las Lajas', 117),\
(5067, 'Las Ovejas', 117),\
(5068, 'Loncopue', 117),\
(5069, 'Los Catutos', 117),\
(5070, 'Los Chihuidos', 117),\
(5071, 'Los Miches', 117),\
(5072, 'Manzano Amargo', 117),\
(5073, 'Neuquen', 117),\
(5074, 'Octavio Pico', 117),\
(5075, 'Paso Aguerre', 117),\
(5076, 'Picun Leufu', 117),\
(5077, 'Piedra del Aguila', 117),\
(5078, 'Pilo Lil', 117),\
(5079, 'Plaza Huincul', 117),\
(5080, 'Plottier', 117),\
(5081, 'Quili Malal', 117),\
(5082, 'Ramon Castro', 117),\
(5083, 'Rincon de Los Sauces', 117),\
(5084, 'San Martin de Los Andes', 117),\
(5085, 'San Patricio del Chaniar', 117),\
(5086, 'Santo Tomas', 117),\
(5087, 'Sauzal Bonito', 117),\
(5088, 'Senillosa', 117),\
(5089, 'Taquimilan', 117),\
(5090, 'Tricao Malal', 117),\
(5091, 'Varvarco', 117),\
(5092, 'Villa Curi Leuvu', 117),\
(5093, 'Villa del Nahueve', 117),\
(5094, 'Villa del Puente Picun Leuvu', 117),\
(5095, 'Villa El Chocon', 117),\
(5096, 'Villa La Angostura', 117),\
(5097, 'Villa Pehuenia', 117),\
(5098, 'Villa Traful', 117),\
(5099, 'Vista Alegre', 117),\
(5100, 'Zapala', 117),\
(5101, 'Aguada Cecilio', 118),\
(5102, 'Aguada de Guerra', 118),\
(5103, 'Allen', 118),\
(5104, 'Arroyo de La Ventana', 118),\
(5105, 'Arroyo Los Berros', 118),\
(5106, 'Bariloche', 118),\
(5107, 'Calte. Cordero', 118),\
(5108, 'Campo Grande', 118),\
(5109, 'Catriel', 118),\
(5110, 'Cerro Policia', 118),\
(5111, 'Cervantes', 118),\
(5112, 'Chelforo', 118),\
(5113, 'Chimpay', 118),\
(5114, 'Chinchinales', 118),\
(5115, 'Chipauquil', 118),\
(5116, 'Choele Choel', 118),\
(5117, 'Cinco Saltos', 118),\
(5118, 'Cipolletti', 118),\
(5119, 'Clemente Onelli', 118),\
(5120, 'Colan Conhue', 118),\
(5121, 'Comallo', 118),\
(5122, 'Comico', 118),\
(5123, 'Cona Niyeu', 118),\
(5124, 'Coronel Belisle', 118),\
(5125, 'Cubanea', 118),\
(5126, 'Darwin', 118),\
(5127, 'Dina Huapi', 118),\
(5128, 'El Bolson', 118),\
(5129, 'El Cain', 118),\
(5130, 'El Manso', 118),\
(5131, 'Gral. Conesa', 118),\
(5132, 'Gral. Enrique Godoy', 118),\
(5133, 'Gral. Fernandez Oro', 118),\
(5134, 'Gral. Roca', 118),\
(5135, 'Guardia Mitre', 118),\
(5136, 'Ing. Huergo', 118),\
(5137, 'Ing. Jacobacci', 118),\
(5138, 'Laguna Blanca', 118),\
(5139, 'Lamarque', 118),\
(5140, 'Las Grutas', 118),\
(5141, 'Los Menucos', 118),\
(5142, 'Luis Beltran', 118),\
(5143, 'Mainque', 118),\
(5144, 'Mamuel Choique', 118),\
(5145, 'Maquinchao', 118),\
(5146, 'Mencue', 118),\
(5147, 'Mtro. Ramos Mexia', 118),\
(5148, 'Nahuel Niyeu', 118),\
(5149, 'Naupa Huen', 118),\
(5150, 'niorquinco', 118),\
(5151, 'Ojos de Agua', 118),\
(5152, 'Paso de Agua', 118),\
(5153, 'Paso Flores', 118),\
(5154, 'Penias Blancas', 118),\
(5155, 'Pichi Mahuida', 118),\
(5156, 'Pilcaniyeu', 118),\
(5157, 'Pomona', 118),\
(5158, 'Prahuaniyeu', 118),\
(5159, 'Rincon Treneta', 118),\
(5160, 'Rio Chico', 118),\
(5161, 'Rio Colorado', 118),\
(5162, 'Roca', 118),\
(5163, 'San Antonio Oeste', 118),\
(5164, 'San Javier', 118),\
(5165, 'Sierra Colorada', 118),\
(5166, 'Sierra Grande', 118),\
(5167, 'Sierra Paileman', 118),\
(5168, 'Valcheta', 118),\
(5169, 'Valle Azul', 118),\
(5170, 'Viedma', 118),\
(5171, 'Villa Llanquin', 118),\
(5172, 'Villa Mascardi', 118),\
(5173, 'Villa Regina', 118),\
(5174, 'Yaminue', 118),\
(5175, 'Aaron Castellanos', 119),\
(5176, 'Acebal', 119),\
(5177, 'Aguara Grande', 119),\
(5178, 'Albarellos', 119),\
(5179, 'Alcorta', 119),\
(5180, 'Aldao', 119),\
(5181, 'Alejandra', 119),\
(5182, 'alvarez', 119),\
(5183, 'Ambrosetti', 119),\
(5184, 'Amenabar', 119),\
(5185, 'Angelica', 119),\
(5186, 'Angeloni', 119),\
(5187, 'Arequito', 119),\
(5188, 'Arminda', 119),\
(5189, 'Armstrong', 119),\
(5190, 'Arocena', 119),\
(5191, 'Arroyo Aguiar', 119),\
(5192, 'Arroyo Ceibal', 119),\
(5193, 'Arroyo Leyes', 119),\
(5194, 'Arroyo Seco', 119),\
(5195, 'Arrufo', 119),\
(5196, 'Arteaga', 119),\
(5197, 'Ataliva', 119),\
(5198, 'Aurelia', 119),\
(5199, 'Avellaneda', 119),\
(5200, 'Barrancas', 119),\
(5201, 'Bauer Y Sigel', 119),\
(5202, 'Bella Italia', 119),\
(5203, 'Berabevu', 119),\
(5204, 'Berna', 119),\
(5205, 'Bernardo de Irigoyen', 119),\
(5206, 'Bigand', 119),\
(5207, 'Bombal', 119),\
(5208, 'Bouquet', 119),\
(5209, 'Bustinza', 119),\
(5210, 'Cabal', 119),\
(5211, 'Cacique Ariacaiquin', 119),\
(5212, 'Cafferata', 119),\
(5213, 'Calchaqui', 119),\
(5214, 'Campo Andino', 119),\
(5215, 'Campo Piaggio', 119),\
(5216, 'Caniada de Gomez', 119),\
(5217, 'Caniada del Ucle', 119),\
(5218, 'Caniada Rica', 119),\
(5219, 'Caniada Rosquin', 119),\
(5220, 'Candioti', 119),\
(5221, 'Capital', 119),\
(5222, 'Capitan Bermudez', 119),\
(5223, 'Capivara', 119),\
(5224, 'Carcarania', 119),\
(5225, 'Carlos Pellegrini', 119),\
(5226, 'Carmen', 119),\
(5227, 'Carmen Del Sauce', 119),\
(5228, 'Carreras', 119),\
(5229, 'Carrizales', 119),\
(5230, 'Casalegno', 119),\
(5231, 'Casas', 119),\
(5232, 'Casilda', 119),\
(5233, 'Castelar', 119),\
(5234, 'Castellanos', 119),\
(5235, 'Cayasta', 119),\
(5236, 'Cayastacito', 119),\
(5237, 'Centeno', 119),\
(5238, 'Cepeda', 119),\
(5239, 'Ceres', 119),\
(5240, 'Chabas', 119),\
(5241, 'Chaniar Ladeado', 119),\
(5242, 'Chapuy', 119),\
(5243, 'Chovet', 119),\
(5244, 'Christophersen', 119),\
(5245, 'Classon', 119),\
(5246, 'Cnel. Arnold', 119),\
(5247, 'Cnel. Bogado', 119),\
(5248, 'Cnel. Dominguez', 119),\
(5249, 'Cnel. Fraga', 119),\
(5250, 'Col. Aldao', 119),\
(5251, 'Col. Ana', 119),\
(5252, 'Col. Belgrano', 119),\
(5253, 'Col. Bicha', 119),\
(5254, 'Col. Bigand', 119),\
(5255, 'Col. Bossi', 119),\
(5256, 'Col. Cavour', 119),\
(5257, 'Col. Cello', 119),\
(5258, 'Col. Dolores', 119),\
(5259, 'Col. Dos Rosas', 119),\
(5260, 'Col. Duran', 119),\
(5261, 'Col. Iturraspe', 119),\
(5262, 'Col. Margarita', 119),\
(5263, 'Col. Mascias', 119),\
(5264, 'Col. Raquel', 119),\
(5265, 'Col. Rosa', 119),\
(5266, 'Col. San Jose', 119),\
(5267, 'Constanza', 119),\
(5268, 'Coronda', 119),\
(5269, 'Correa', 119),\
(5270, 'Crispi', 119),\
(5271, 'Cululu', 119),\
(5272, 'Curupayti', 119),\
(5273, 'Desvio Arijon', 119),\
(5274, 'Diaz', 119),\
(5275, 'Diego de Alvear', 119),\
(5276, 'Egusquiza', 119),\
(5277, 'El Araza', 119),\
(5278, 'El Rabon', 119),\
(5279, 'El Sombrerito', 119),\
(5280, 'El Trebol', 119),\
(5281, 'Elisa', 119),\
(5282, 'Elortondo', 119),\
(5283, 'Emilia', 119),\
(5284, 'Empalme San Carlos', 119),\
(5285, 'Empalme Villa Constitucion', 119),\
(5286, 'Esmeralda', 119),\
(5287, 'Esperanza', 119),\
(5288, 'Estacion Alvear', 119),\
(5289, 'Estacion Clucellas', 119),\
(5290, 'Esteban Rams', 119),\
(5291, 'Esther', 119),\
(5292, 'Esustolia', 119),\
(5293, 'Eusebia', 119),\
(5294, 'Felicia', 119),\
(5295, 'Fidela', 119),\
(5296, 'Fighiera', 119),\
(5297, 'Firmat', 119),\
(5298, 'Florencia', 119),\
(5299, 'Fortin Olmos', 119),\
(5300, 'Franck', 119),\
(5301, 'Fray Luis Beltran', 119),\
(5302, 'Frontera', 119),\
(5303, 'Fuentes', 119),\
(5304, 'Funes', 119),\
(5305, 'Gaboto', 119),\
(5306, 'Galisteo', 119),\
(5307, 'Galvez', 119),\
(5308, 'Garabalto', 119),\
(5309, 'Garibaldi', 119),\
(5310, 'Gato Colorado', 119),\
(5311, 'Gdor. Crespo', 119),\
(5312, 'Gessler', 119),\
(5313, 'Godoy', 119),\
(5314, 'Golondrina', 119),\
(5315, 'Gral. Gelly', 119),\
(5316, 'Gral. Lagos', 119),\
(5317, 'Granadero Baigorria', 119),\
(5318, 'Gregoria Perez De Denis', 119),\
(5319, 'Grutly', 119),\
(5320, 'Guadalupe N.', 119),\
(5321, 'G?deken', 119),\
(5322, 'Helvecia', 119),\
(5323, 'Hersilia', 119),\
(5324, 'Hipatia', 119),\
(5325, 'Huanqueros', 119),\
(5326, 'Hugentobler', 119),\
(5327, 'Hughes', 119),\
(5328, 'Humberto 1', 119),\
(5329, 'Humboldt', 119),\
(5330, 'Ibarlucea', 119),\
(5331, 'Ing. Chanourdie', 119),\
(5332, 'Intiyaco', 119),\
(5333, 'Ituzaingo', 119),\
(5334, 'Jacinto L. Arauz', 119),\
(5335, 'Josefina', 119),\
(5336, 'Juan B. Molina', 119),\
(5337, 'Juan de Garay', 119),\
(5338, 'Juncal', 119),\
(5339, 'La Brava', 119),\
(5340, 'La Cabral', 119),\
(5341, 'La Camila', 119),\
(5342, 'La Chispa', 119),\
(5343, 'La Clara', 119),\
(5344, 'La Criolla', 119),\
(5345, 'La Gallareta', 119),\
(5346, 'La Lucila', 119),\
(5347, 'La Pelada', 119),\
(5348, 'La Penca', 119),\
(5349, 'La Rubia', 119),\
(5350, 'La Sarita', 119),\
(5351, 'La Vanguardia', 119),\
(5352, 'Labordeboy', 119),\
(5353, 'Laguna Paiva', 119),\
(5354, 'Landeta', 119),\
(5355, 'Lanteri', 119),\
(5356, 'Larrechea', 119),\
(5357, 'Las Avispas', 119),\
(5358, 'Las Bandurrias', 119),\
(5359, 'Las Garzas', 119),\
(5360, 'Las Palmeras', 119),\
(5361, 'Las Parejas', 119),\
(5362, 'Las Petacas', 119),\
(5363, 'Las Rosas', 119),\
(5364, 'Las Toscas', 119),\
(5365, 'Las Tunas', 119),\
(5366, 'Lazzarino', 119),\
(5367, 'Lehmann', 119),\
(5368, 'Llambi Campbell', 119),\
(5369, 'Logronio', 119),\
(5370, 'Loma Alta', 119),\
(5371, 'Lopez', 119),\
(5372, 'Los Amores', 119),\
(5373, 'Los Cardos', 119),\
(5374, 'Los Laureles', 119),\
(5375, 'Los Molinos', 119),\
(5376, 'Los Quirquinchos', 119),\
(5377, 'Lucio V. Lopez', 119),\
(5378, 'Luis Palacios', 119),\
(5379, 'Ma. Juana', 119),\
(5380, 'Ma. Luisa', 119),\
(5381, 'Ma. Susana', 119),\
(5382, 'Ma. Teresa', 119),\
(5383, 'Maciel', 119),\
(5384, 'Maggiolo', 119),\
(5385, 'Malabrigo', 119),\
(5386, 'Marcelino Escalada', 119),\
(5387, 'Margarita', 119),\
(5388, 'Matilde', 119),\
(5389, 'Maua', 119),\
(5390, 'Maximo Paz', 119),\
(5391, 'Melincue', 119),\
(5392, 'Miguel Torres', 119),\
(5393, 'Moises Ville', 119),\
(5394, 'Monigotes', 119),\
(5395, 'Monje', 119),\
(5396, 'Monte Obscuridad', 119),\
(5397, 'Monte Vera', 119),\
(5398, 'Montefiore', 119),\
(5399, 'Montes de Oca', 119),\
(5400, 'Murphy', 119),\
(5401, 'nianducita', 119),\
(5402, 'Nare', 119),\
(5403, 'Nelson', 119),\
(5404, 'Nicanor E. Molinas', 119),\
(5405, 'Nuevo Torino', 119),\
(5406, 'Oliveros', 119),\
(5407, 'Palacios', 119),\
(5408, 'Pavon', 119),\
(5409, 'Pavon Arriba', 119),\
(5410, 'Pedro Gomez Cello', 119),\
(5411, 'Perez', 119),\
(5412, 'Peyrano', 119),\
(5413, 'Piamonte', 119),\
(5414, 'Pilar', 119),\
(5415, 'Piniero', 119),\
(5416, 'Plaza Clucellas', 119),\
(5417, 'Portugalete', 119),\
(5418, 'Pozo Borrado', 119),\
(5419, 'Progreso', 119),\
(5420, 'Providencia', 119),\
(5421, 'Pte. Roca', 119),\
(5422, 'Pueblo Andino', 119),\
(5423, 'Pueblo Esther', 119),\
(5424, 'Pueblo Gral. San Martin', 119),\
(5425, 'Pueblo Irigoyen', 119),\
(5426, 'Pueblo Marini', 119),\
(5427, 'Pueblo Munioz', 119),\
(5428, 'Pueblo Uranga', 119),\
(5429, 'Pujato', 119),\
(5430, 'Pujato N.', 119),\
(5431, 'Rafaela', 119),\
(5432, 'Ramayon', 119),\
(5433, 'Ramona', 119),\
(5434, 'Reconquista', 119),\
(5435, 'Recreo', 119),\
(5436, 'Ricardone', 119),\
(5437, 'Rivadavia', 119),\
(5438, 'Roldan', 119),\
(5439, 'Romang', 119),\
(5440, 'Rosario', 119),\
(5441, 'Rueda', 119),\
(5442, 'Rufino', 119),\
(5443, 'Sa Pereira', 119),\
(5444, 'Saguier', 119),\
(5445, 'Saladero M. Cabal', 119),\
(5446, 'Salto Grande', 119),\
(5447, 'San Agustin', 119),\
(5448, 'San Antonio de Obligado', 119),\
(5449, 'San Bernardo N.J.', 119),\
(5450, 'San Bernardo S.J.', 119),\
(5451, 'San Carlos Centro', 119),\
(5452, 'San Carlos N.', 119),\
(5453, 'San Carlos S.', 119),\
(5454, 'San Cristobal', 119),\
(5455, 'San Eduardo', 119),\
(5456, 'San Eugenio', 119),\
(5457, 'San Fabian', 119),\
(5458, 'San Fco. de Santa Fe', 119),\
(5459, 'San Genaro', 119),\
(5460, 'San Genaro N.', 119),\
(5461, 'San Gregorio', 119),\
(5462, 'San Guillermo', 119),\
(5463, 'San Javier', 119),\
(5464, 'San Jeronimo del Sauce', 119),\
(5465, 'San Jeronimo N.', 119),\
(5466, 'San Jeronimo S.', 119),\
(5467, 'San Jorge', 119),\
(5468, 'San Jose de La Esquina', 119),\
(5469, 'San Jose del Rincon', 119),\
(5470, 'San Justo', 119),\
(5471, 'San Lorenzo', 119),\
(5472, 'San Mariano', 119),\
(5473, 'San Martin de Las Escobas', 119),\
(5474, 'San Martin N.', 119),\
(5475, 'San Vicente', 119),\
(5476, 'Sancti Spititu', 119),\
(5477, 'Sanford', 119),\
(5478, 'Santo Domingo', 119),\
(5479, 'Santo Tome', 119),\
(5480, 'Santurce', 119),\
(5481, 'Sargento Cabral', 119),\
(5482, 'Sarmiento', 119),\
(5483, 'Sastre', 119),\
(5484, 'Sauce Viejo', 119),\
(5485, 'Serodino', 119),\
(5486, 'Silva', 119),\
(5487, 'Soldini', 119),\
(5488, 'Soledad', 119),\
(5489, 'Soutomayor', 119),\
(5490, 'Sta. Clara de Buena Vista', 119),\
(5491, 'Sta. Clara de Saguier', 119),\
(5492, 'Sta. Isabel', 119),\
(5493, 'Sta. Margarita', 119),\
(5494, 'Sta. Maria Centro', 119),\
(5495, 'Sta. Maria N.', 119),\
(5496, 'Sta. Rosa', 119),\
(5497, 'Sta. Teresa', 119),\
(5498, 'Suardi', 119),\
(5499, 'Sunchales', 119),\
(5500, 'Susana', 119),\
(5501, 'Tacuarendi', 119),\
(5502, 'Tacural', 119),\
(5503, 'Tartagal', 119),\
(5504, 'Teodelina', 119),\
(5505, 'Theobald', 119),\
(5506, 'Timbues', 119),\
(5507, 'Toba', 119),\
(5508, 'Tortugas', 119),\
(5509, 'Tostado', 119),\
(5510, 'Totoras', 119),\
(5511, 'Traill', 119),\
(5512, 'Venado Tuerto', 119),\
(5513, 'Vera', 119),\
(5514, 'Vera y Pintado', 119),\
(5515, 'Videla', 119),\
(5516, 'Vila', 119),\
(5517, 'Villa Amelia', 119),\
(5518, 'Villa Ana', 119),\
(5519, 'Villa Canias', 119),\
(5520, 'Villa Constitucion', 119),\
(5521, 'Villa Eloisa', 119),\
(5522, 'Villa Gdor. Galvez', 119),\
(5523, 'Villa Guillermina', 119),\
(5524, 'Villa Minetti', 119),\
(5525, 'Villa Mugueta', 119),\
(5526, 'Villa Ocampo', 119),\
(5527, 'Villa San Jose', 119),\
(5528, 'Villa Saralegui', 119),\
(5529, 'Villa Trinidad', 119),\
(5530, 'Villada', 119),\
(5531, 'Virginia', 119),\
(5532, 'Wheelwright', 119),\
(5533, 'Zavalla', 119),\
(5534, 'Acheral', 120),\
(5535, 'Agua Dulce', 120),\
(5536, 'Aguilares', 120),\
(5537, 'Alderetes', 120),\
(5538, 'Alpachiri', 120),\
(5539, 'Alto Verde', 120),\
(5540, 'Amaicha del Valle', 120),\
(5541, 'Amberes', 120),\
(5542, 'Ancajuli', 120),\
(5543, 'Arcadia', 120),\
(5544, 'Atahona', 120),\
(5545, 'Banda del Rio Sali', 120),\
(5546, 'Bella Vista', 120),\
(5547, 'Buena Vista', 120),\
(5548, 'Burruyacu', 120),\
(5549, 'Capitan Caceres', 120),\
(5550, 'Cevil Redondo', 120),\
(5551, 'Choromoro', 120),\
(5552, 'Ciudacita', 120),\
(5553, 'Colalao del Valle', 120),\
(5554, 'Colombres', 120),\
(5555, 'Concepcion', 120),\
(5556, 'Delfin Gallo', 120),\
(5557, 'El Bracho', 120),\
(5558, 'El Cadillal', 120),\
(5559, 'El Cercado', 120),\
(5560, 'El Chaniar', 120),\
(5561, 'El Manantial', 120),\
(5562, 'El Mojon', 120),\
(5563, 'El Mollar', 120),\
(5564, 'El Naranjito', 120),\
(5565, 'El Naranjo', 120),\
(5566, 'El Polear', 120),\
(5567, 'El Puestito', 120),\
(5568, 'El Sacrificio', 120),\
(5569, 'El Timbo', 120),\
(5570, 'Escaba', 120),\
(5571, 'Esquina', 120),\
(5572, 'Estacion Araoz', 120),\
(5573, 'Famailla', 120),\
(5574, 'Gastone', 120),\
(5575, 'Gdor. Garmendia', 120),\
(5576, 'Gdor. Piedrabuena', 120),\
(5577, 'Graneros', 120),\
(5578, 'Huasa Pampa', 120),\
(5579, 'J. B. Alberdi', 120),\
(5580, 'La Cocha', 120),\
(5581, 'La Esperanza', 120),\
(5582, 'La Florida', 120),\
(5583, 'La Ramada', 120),\
(5584, 'La Trinidad', 120),\
(5585, 'Lamadrid', 120),\
(5586, 'Las Cejas', 120),\
(5587, 'Las Talas', 120),\
(5588, 'Las Talitas', 120),\
(5589, 'Los Bulacio', 120),\
(5590, 'Los Gomez', 120),\
(5591, 'Los Nogales', 120),\
(5592, 'Los Pereyra', 120),\
(5593, 'Los Perez', 120),\
(5594, 'Los Puestos', 120),\
(5595, 'Los Ralos', 120),\
(5596, 'Los Sarmientos', 120),\
(5597, 'Los Sosa', 120),\
(5598, 'Lules', 120),\
(5599, 'M. Garcia Fernandez', 120),\
(5600, 'Manuela Pedraza', 120),\
(5601, 'Medinas', 120),\
(5602, 'Monte Bello', 120),\
(5603, 'Monteagudo', 120),\
(5604, 'Monteros', 120),\
(5605, 'Padre Monti', 120),\
(5606, 'Pampa Mayo', 120),\
(5607, 'Quilmes', 120),\
(5608, 'Raco', 120),\
(5609, 'Ranchillos', 120),\
(5610, 'Rio Chico', 120),\
(5611, 'Rio Colorado', 120),\
(5612, 'Rio Seco', 120),\
(5613, 'Rumi Punco', 120),\
(5614, 'San Andres', 120),\
(5615, 'San Felipe', 120),\
(5616, 'San Ignacio', 120),\
(5617, 'San Javier', 120),\
(5618, 'San Jose', 120),\
(5619, 'San Miguel de Tucuman', 120),\
(5620, 'San Pedro', 120),\
(5621, 'San Pedro de Colalao', 120),\
(5622, 'Santa Rosa de Leales', 120),\
(5623, 'Sgto. Moya', 120),\
(5624, 'Siete de Abril', 120),\
(5625, 'Simoca', 120),\
(5626, 'Soldado Maldonado', 120),\
(5627, 'Sta. Ana', 120),\
(5628, 'Sta. Cruz', 120),\
(5629, 'Sta. Lucia', 120),\
(5630, 'Taco Ralo', 120),\
(5631, 'Tafi del Valle', 120),\
(5632, 'Tafi Viejo', 120),\
(5633, 'Tapia', 120),\
(5634, 'Teniente Berdina', 120),\
(5635, 'Trancas', 120),\
(5636, 'Villa Belgrano', 120),\
(5637, 'Villa Benjamin Araoz', 120),\
(5638, 'Villa Chiligasta', 120),\
(5639, 'Villa de Leales', 120),\
(5640, 'Villa Quinteros', 120),\
(5641, 'Yanima', 120),\
(5642, 'Yerba Buena', 120),\
(5643, 'Yerba Buena S', 120),\
(5644, 'Aldea Apeleg', 121),\
(5645, 'Aldea Beleiro', 121),\
(5646, 'Aldea Epulef', 121),\
(5647, 'Alto Rio Sengerr', 121),\
(5648, 'Buen Pasto', 121),\
(5649, 'Camarones', 121),\
(5650, 'Carrenleufu', 121),\
(5651, 'Cholila', 121),\
(5652, 'Co. Centinela', 121),\
(5653, 'Colan Conhue', 121),\
(5654, 'Comodoro Rivadavia', 121),\
(5655, 'Corcovado', 121),\
(5656, 'Cushamen', 121),\
(5657, 'Dique F. Ameghino', 121),\
(5658, 'Dolavon', 121),\
(5659, 'Dr. R. Rojas', 121),\
(5660, 'El Hoyo', 121),\
(5661, 'El Maiten', 121),\
(5662, 'Epuyen', 121),\
(5663, 'Esquel', 121),\
(5664, 'Facundo', 121),\
(5665, 'Gaiman', 121),\
(5666, 'Gan Gan', 121),\
(5667, 'Gastre', 121),\
(5668, 'Gdor. Costa', 121),\
(5669, 'Gualjaina', 121),\
(5670, 'J. de San Martin', 121),\
(5671, 'Lago Blanco', 121),\
(5672, 'Lago Puelo', 121),\
(5673, 'Lagunita Salada', 121),\
(5674, 'Las Plumas', 121),\
(5675, 'Los Altares', 121),\
(5676, 'Paso de los Indios', 121),\
(5677, 'Paso del Sapo', 121),\
(5678, 'Pto. Madryn', 121),\
(5679, 'Pto. Piramides', 121),\
(5680, 'Rada Tilly', 121),\
(5681, 'Rawson', 121),\
(5682, 'Rio Mayo', 121),\
(5683, 'Rio Pico', 121),\
(5684, 'Sarmiento', 121),\
(5685, 'Tecka', 121),\
(5686, 'Telsen', 121),\
(5687, 'Trelew', 121),\
(5688, 'Trevelin', 121),\
(5689, 'Veintiocho de Julio', 121),\
(5690, 'Rio Grande', 122),\
(5691, 'Tolhuin', 122),\
(5692, 'Ushuaia', 122),\
(5693, 'Alvear', 123),\
(5694, 'Bella Vista', 123),\
(5695, 'Beron de Astrada', 123),\
(5696, 'Bonpland', 123),\
(5697, 'Caa Cati', 123),\
(5698, 'Capital', 123),\
(5699, 'Chavarria', 123),\
(5700, 'Col. C. Pellegrini', 123),\
(5701, 'Col. Libertad', 123),\
(5702, 'Col. Liebig', 123),\
(5703, 'Col. Sta Rosa', 123),\
(5704, 'Concepcion', 123),\
(5705, 'Cruz de Los Milagros', 123),\
(5706, 'Curuzu-Cuatia', 123),\
(5707, 'Empedrado', 123),\
(5708, 'Esquina', 123),\
(5709, 'Estacion Torrent', 123),\
(5710, 'Felipe Yofre', 123),\
(5711, 'Garruchos', 123),\
(5712, 'Gdor. Agronomo', 123),\
(5713, 'Gdor. Martinez', 123),\
(5714, 'Goya', 123),\
(5715, 'Guaviravi', 123),\
(5716, 'Herlitzka', 123),\
(5717, 'Ita-Ibate', 123),\
(5718, 'Itati', 123),\
(5719, 'Ituzaingo', 123),\
(5720, 'Jose Rafael Gomez', 123),\
(5721, 'Juan Pujol', 123),\
(5722, 'La Cruz', 123),\
(5723, 'Lavalle', 123),\
(5724, 'Lomas de Vallejos', 123),\
(5725, 'Loreto', 123),\
(5726, 'Mariano I. Loza', 123),\
(5727, 'Mburucuya', 123),\
(5728, 'Mercedes', 123),\
(5729, 'Mocoreta', 123),\
(5730, 'Mte. Caseros', 123),\
(5731, 'Nueve de Julio', 123),\
(5732, 'Palmar Grande', 123),\
(5733, 'Parada Pucheta', 123),\
(5734, 'Paso de La Patria', 123),\
(5735, 'Paso de Los Libres', 123),\
(5736, 'Pedro R. Fernandez', 123),\
(5737, 'Perugorria', 123),\
(5738, 'Pueblo Libertador', 123),\
(5739, 'Ramada Paso', 123),\
(5740, 'Riachuelo', 123),\
(5741, 'Saladas', 123),\
(5742, 'San Antonio', 123),\
(5743, 'San Carlos', 123),\
(5744, 'San Cosme', 123),\
(5745, 'San Lorenzo', 123),\
(5746, 'San Luis del Palmar', 123),\
(5747, 'San Miguel', 123),\
(5748, 'San Roque', 123),\
(5749, 'Santa Ana', 123),\
(5750, 'Santa Lucia', 123),\
(5751, 'Santo Tome', 123),\
(5752, 'Sauce', 123),\
(5753, 'Tabay', 123),\
(5754, 'Tapebicua', 123),\
(5755, 'Tatacua', 123),\
(5756, 'Virasoro', 123),\
(5757, 'Yapeyu', 123),\
(5758, 'Yataiti Calle', 123),\
(5759, 'Achiras', 124),\
(5760, 'Adelia Maria', 124),\
(5761, 'Agua de Oro', 124),\
(5762, 'Alcira Gigena', 124),\
(5763, 'Aldea Santa Maria', 124),\
(5764, 'Alejandro Roca', 124),\
(5765, 'Alejo Ledesma', 124),\
(5766, 'Alicia', 124),\
(5767, 'Almafuerte', 124),\
(5768, 'Alpa Corral', 124),\
(5769, 'Alta Gracia', 124),\
(5770, 'Alto Alegre', 124),\
(5771, 'Alto de Los Quebrachos', 124),\
(5772, 'Altos de Chipion', 124),\
(5773, 'Amboy', 124),\
(5774, 'Ambul', 124),\
(5775, 'Ana Zumaran', 124),\
(5776, 'Anisacate', 124),\
(5777, 'Arguello', 124),\
(5778, 'Arias', 124),\
(5779, 'Arroyito', 124),\
(5780, 'Arroyo Algodon', 124),\
(5781, 'Arroyo Cabral', 124),\
(5782, 'Arroyo Los Patos', 124),\
(5783, 'Assunta', 124),\
(5784, 'Atahona', 124),\
(5785, 'Ausonia', 124),\
(5786, 'Avellaneda', 124),\
(5787, 'Ballesteros', 124),\
(5788, 'Ballesteros Sud', 124),\
(5789, 'Balnearia', 124),\
(5790, 'Baniado de Soto', 124),\
(5791, 'Bell Ville', 124),\
(5792, 'Bengolea', 124),\
(5793, 'Benjamin Gould', 124),\
(5794, 'Berrotaran', 124),\
(5795, 'Bialet Masse', 124),\
(5796, 'Bouwer', 124),\
(5797, 'Brinkmann', 124),\
(5798, 'Buchardo', 124),\
(5799, 'Bulnes', 124),\
(5800, 'Cabalango', 124),\
(5801, 'Calamuchita', 124),\
(5802, 'Calchin', 124),\
(5803, 'Calchin Oeste', 124),\
(5804, 'Calmayo', 124),\
(5805, 'Camilo Aldao', 124),\
(5806, 'Caminiaga', 124),\
(5807, 'Caniada de Luque', 124),\
(5808, 'Caniada de Machado', 124),\
(5809, 'Caniada de Rio Pinto', 124),\
(5810, 'Caniada del Sauce', 124),\
(5811, 'Canals', 124),\
(5812, 'Candelaria Sud', 124),\
(5813, 'Capilla de Remedios', 124),\
(5814, 'Capilla de Siton', 124),\
(5815, 'Capilla del Carmen', 124),\
(5816, 'Capilla del Monte', 124),\
(5817, 'Capital', 124),\
(5818, 'Capitan Gral B. O?Higgins', 124),\
(5819, 'Carnerillo', 124),\
(5820, 'Carrilobo', 124),\
(5821, 'Casa Grande', 124),\
(5822, 'Cavanagh', 124),\
(5823, 'Cerro Colorado', 124),\
(5824, 'Chajan', 124),\
(5825, 'Chalacea', 124),\
(5826, 'Chaniar Viejo', 124),\
(5827, 'Chancani', 124),\
(5828, 'Charbonier', 124),\
(5829, 'Charras', 124),\
(5830, 'Chazon', 124),\
(5831, 'Chilibroste', 124),\
(5832, 'Chucul', 124),\
(5833, 'Chunia', 124);\
INSERT INTO `cities` (`id`, `name`, `region_id`) VALUES\
(5834, 'Chunia Huasi', 124),\
(5835, 'Churqui Caniada', 124),\
(5836, 'Cienaga Del Coro', 124),\
(5837, 'Cintra', 124),\
(5838, 'Col. Almada', 124),\
(5839, 'Col. Anita', 124),\
(5840, 'Col. Barge', 124),\
(5841, 'Col. Bismark', 124),\
(5842, 'Col. Bremen', 124),\
(5843, 'Col. Caroya', 124),\
(5844, 'Col. Italiana', 124),\
(5845, 'Col. Iturraspe', 124),\
(5846, 'Col. Las Cuatro Esquinas', 124),\
(5847, 'Col. Las Pichanas', 124),\
(5848, 'Col. Marina', 124),\
(5849, 'Col. Prosperidad', 124),\
(5850, 'Col. San Bartolome', 124),\
(5851, 'Col. San Pedro', 124),\
(5852, 'Col. Tirolesa', 124),\
(5853, 'Col. Vicente Aguero', 124),\
(5854, 'Col. Videla', 124),\
(5855, 'Col. Vignaud', 124),\
(5856, 'Col. Waltelina', 124),\
(5857, 'Colazo', 124),\
(5858, 'Comechingones', 124),\
(5859, 'Conlara', 124),\
(5860, 'Copacabana', 124),\
(5861, 'Cordoba', 124),\
(5862, 'Coronel Baigorria', 124),\
(5863, 'Coronel Moldes', 124),\
(5864, 'Corral de Bustos', 124),\
(5865, 'Corralito', 124),\
(5866, 'Cosquin', 124),\
(5867, 'Costa Sacate', 124),\
(5868, 'Cruz Alta', 124),\
(5869, 'Cruz de Cania', 124),\
(5870, 'Cruz del Eje', 124),\
(5871, 'Cuesta Blanca', 124),\
(5872, 'Dean Funes', 124),\
(5873, 'Del Campillo', 124),\
(5874, 'Despeniaderos', 124),\
(5875, 'Devoto', 124),\
(5876, 'Diego de Rojas', 124),\
(5877, 'Dique Chico', 124),\
(5878, 'El Araniado', 124),\
(5879, 'El Brete', 124),\
(5880, 'El Chacho', 124),\
(5881, 'El Crispin', 124),\
(5882, 'El Fortin', 124),\
(5883, 'El Manzano', 124),\
(5884, 'El Rastreador', 124),\
(5885, 'El Rodeo', 124),\
(5886, 'El Tio', 124),\
(5887, 'Elena', 124),\
(5888, 'Embalse', 124),\
(5889, 'Esquina', 124),\
(5890, 'Estacion Gral. Paz', 124),\
(5891, 'Estacion Juarez Celman', 124),\
(5892, 'Estancia de Guadalupe', 124),\
(5893, 'Estancia Vieja', 124),\
(5894, 'Etruria', 124),\
(5895, 'Eufrasio Loza', 124),\
(5896, 'Falda del Carmen', 124),\
(5897, 'Freyre', 124),\
(5898, 'Gral. Baldissera', 124),\
(5899, 'Gral. Cabrera', 124),\
(5900, 'Gral. Deheza', 124),\
(5901, 'Gral. Fotheringham', 124),\
(5902, 'Gral. Levalle', 124),\
(5903, 'Gral. Roca', 124),\
(5904, 'Guanaco Muerto', 124),\
(5905, 'Guasapampa', 124),\
(5906, 'Guatimozin', 124),\
(5907, 'Gutenberg', 124),\
(5908, 'Hernando', 124),\
(5909, 'Huanchillas', 124),\
(5910, 'Huerta Grande', 124),\
(5911, 'Huinca Renanco', 124),\
(5912, 'Idiazabal', 124),\
(5913, 'Impira', 124),\
(5914, 'Inriville', 124),\
(5915, 'Isla Verde', 124),\
(5916, 'Italo', 124),\
(5917, 'James Craik', 124),\
(5918, 'Jesus Maria', 124),\
(5919, 'Jovita', 124),\
(5920, 'Justiniano Posse', 124),\
(5921, 'Km 658', 124),\
(5922, 'L. V. Mansilla', 124),\
(5923, 'La Batea', 124),\
(5924, 'La Calera', 124),\
(5925, 'La Carlota', 124),\
(5926, 'La Carolina', 124),\
(5927, 'La Cautiva', 124),\
(5928, 'La Cesira', 124),\
(5929, 'La Cruz', 124),\
(5930, 'La Cumbre', 124),\
(5931, 'La Cumbrecita', 124),\
(5932, 'La Falda', 124),\
(5933, 'La Francia', 124),\
(5934, 'La Granja', 124),\
(5935, 'La Higuera', 124),\
(5936, 'La Laguna', 124),\
(5937, 'La Paisanita', 124),\
(5938, 'La Palestina', 124),\
(5939, 'La Pampa', 124),\
(5940, 'La Paquita', 124),\
(5941, 'La Para', 124),\
(5942, 'La Paz', 124),\
(5943, 'La Playa', 124),\
(5944, 'La Playosa', 124),\
(5945, 'La Poblacion', 124),\
(5946, 'La Posta', 124),\
(5947, 'La Puerta', 124),\
(5948, 'La Quinta', 124),\
(5949, 'La Rancherita', 124),\
(5950, 'La Rinconada', 124),\
(5951, 'La Serranita', 124),\
(5952, 'La Tordilla', 124),\
(5953, 'Laborde', 124),\
(5954, 'Laboulaye', 124),\
(5955, 'Laguna Larga', 124),\
(5956, 'Las Acequias', 124),\
(5957, 'Las Albahacas', 124),\
(5958, 'Las Arrias', 124),\
(5959, 'Las Bajadas', 124),\
(5960, 'Las Caleras', 124),\
(5961, 'Las Calles', 124),\
(5962, 'Las Caniadas', 124),\
(5963, 'Las Gramillas', 124),\
(5964, 'Las Higueras', 124),\
(5965, 'Las Isletillas', 124),\
(5966, 'Las Junturas', 124),\
(5967, 'Las Palmas', 124),\
(5968, 'Las Penias', 124),\
(5969, 'Las Penias Sud', 124),\
(5970, 'Las Perdices', 124),\
(5971, 'Las Playas', 124),\
(5972, 'Las Rabonas', 124),\
(5973, 'Las Saladas', 124),\
(5974, 'Las Tapias', 124),\
(5975, 'Las Varas', 124),\
(5976, 'Las Varillas', 124),\
(5977, 'Las Vertientes', 124),\
(5978, 'Leguizamon', 124),\
(5979, 'Leones', 124),\
(5980, 'Los Cedros', 124),\
(5981, 'Los Cerrillos', 124),\
(5982, 'Los Chaniaritos C.E', 124),\
(5983, 'Los Chanaritos R.S', 124),\
(5984, 'Los Cisnes', 124),\
(5985, 'Los Cocos', 124),\
(5986, 'Los Condores', 124),\
(5987, 'Los Hornillos', 124),\
(5988, 'Los Hoyos', 124),\
(5989, 'Los Mistoles', 124),\
(5990, 'Los Molinos', 124),\
(5991, 'Los Pozos', 124),\
(5992, 'Los Reartes', 124),\
(5993, 'Los Surgentes', 124),\
(5994, 'Los Talares', 124),\
(5995, 'Los Zorros', 124),\
(5996, 'Lozada', 124),\
(5997, 'Luca', 124),\
(5998, 'Luque', 124),\
(5999, 'Luyaba', 124),\
(6000, 'Malaguenio', 124),\
(6001, 'Malena', 124),\
(6002, 'Malvinas Argentinas', 124),\
(6003, 'Manfredi', 124),\
(6004, 'Maquinista Gallini', 124),\
(6005, 'Marcos Juarez', 124),\
(6006, 'Marull', 124),\
(6007, 'Matorrales', 124),\
(6008, 'Mattaldi', 124),\
(6009, 'Mayu Sumaj', 124),\
(6010, 'Media Naranja', 124),\
(6011, 'Melo', 124),\
(6012, 'Mendiolaza', 124),\
(6013, 'Mi Granja', 124),\
(6014, 'Mina Clavero', 124),\
(6015, 'Miramar', 124),\
(6016, 'Morrison', 124),\
(6017, 'Morteros', 124),\
(6018, 'Mte. Buey', 124),\
(6019, 'Mte. Cristo', 124),\
(6020, 'Mte. De Los Gauchos', 124),\
(6021, 'Mte. Lenia', 124),\
(6022, 'Mte. Maiz', 124),\
(6023, 'Mte. Ralo', 124),\
(6024, 'Nicolas Bruzone', 124),\
(6025, 'Noetinger', 124),\
(6026, 'Nono', 124),\
(6027, 'Nueva Cordoba', 124),\
(6028, 'Obispo Trejo', 124),\
(6029, 'Olaeta', 124),\
(6030, 'Oliva', 124),\
(6031, 'Olivares San Nicolas', 124),\
(6032, 'Onagolty', 124),\
(6033, 'Oncativo', 124),\
(6034, 'Ordoniez', 124),\
(6035, 'Pacheco De Melo', 124),\
(6036, 'Pampayasta N.', 124),\
(6037, 'Pampayasta S.', 124),\
(6038, 'Panaholma', 124),\
(6039, 'Pascanas', 124),\
(6040, 'Pasco', 124),\
(6041, 'Paso del Durazno', 124),\
(6042, 'Paso Viejo', 124),\
(6043, 'Pilar', 124),\
(6044, 'Pincen', 124),\
(6045, 'Piquillin', 124),\
(6046, 'Plaza de Mercedes', 124),\
(6047, 'Plaza Luxardo', 124),\
(6048, 'Portenia', 124),\
(6049, 'Potrero de Garay', 124),\
(6050, 'Pozo del Molle', 124),\
(6051, 'Pozo Nuevo', 124),\
(6052, 'Pueblo Italiano', 124),\
(6053, 'Puesto de Castro', 124),\
(6054, 'Punta del Agua', 124),\
(6055, 'Quebracho Herrado', 124),\
(6056, 'Quilino', 124),\
(6057, 'Rafael Garcia', 124),\
(6058, 'Ranqueles', 124),\
(6059, 'Rayo Cortado', 124),\
(6060, 'Reduccion', 124),\
(6061, 'Rincon', 124),\
(6062, 'Rio Bamba', 124),\
(6063, 'Rio Ceballos', 124),\
(6064, 'Rio Cuarto', 124),\
(6065, 'Rio de Los Sauces', 124),\
(6066, 'Rio Primero', 124),\
(6067, 'Rio Segundo', 124),\
(6068, 'Rio Tercero', 124),\
(6069, 'Rosales', 124),\
(6070, 'Rosario del Saladillo', 124),\
(6071, 'Sacanta', 124),\
(6072, 'Sagrada Familia', 124),\
(6073, 'Saira', 124),\
(6074, 'Saladillo', 124),\
(6075, 'Saldan', 124),\
(6076, 'Salsacate', 124),\
(6077, 'Salsipuedes', 124),\
(6078, 'Sampacho', 124),\
(6079, 'San Agustin', 124),\
(6080, 'San Antonio de Arredondo', 124),\
(6081, 'San Antonio de Litin', 124),\
(6082, 'San Basilio', 124),\
(6083, 'San Carlos Minas', 124),\
(6084, 'San Clemente', 124),\
(6085, 'San Esteban', 124),\
(6086, 'San Francisco', 124),\
(6087, 'San Ignacio', 124),\
(6088, 'San Javier', 124),\
(6089, 'San Jeronimo', 124),\
(6090, 'San Joaquin', 124),\
(6091, 'San Jose de La Dormida', 124),\
(6092, 'San Jose de Las Salinas', 124),\
(6093, 'San Lorenzo', 124),\
(6094, 'San Marcos Sierras', 124),\
(6095, 'San Marcos Sud', 124),\
(6096, 'San Pedro', 124),\
(6097, 'San Pedro N.', 124),\
(6098, 'San Roque', 124),\
(6099, 'San Vicente', 124),\
(6100, 'Santa Catalina', 124),\
(6101, 'Santa Elena', 124),\
(6102, 'Santa Eufemia', 124),\
(6103, 'Santa Maria', 124),\
(6104, 'Sarmiento', 124),\
(6105, 'Saturnino M.Laspiur', 124),\
(6106, 'Sauce Arriba', 124),\
(6107, 'Sebastian Elcano', 124),\
(6108, 'Seeber', 124),\
(6109, 'Segunda Usina', 124),\
(6110, 'Serrano', 124),\
(6111, 'Serrezuela', 124),\
(6112, 'Sgo. Temple', 124),\
(6113, 'Silvio Pellico', 124),\
(6114, 'Simbolar', 124),\
(6115, 'Sinsacate', 124),\
(6116, 'Sta. Rosa de Calamuchita', 124),\
(6117, 'Sta. Rosa de Rio Primero', 124),\
(6118, 'Suco', 124),\
(6119, 'Tala Caniada', 124),\
(6120, 'Tala Huasi', 124),\
(6121, 'Talaini', 124),\
(6122, 'Tancacha', 124),\
(6123, 'Tanti', 124),\
(6124, 'Ticino', 124),\
(6125, 'Tinoco', 124),\
(6126, 'Tio Pujio', 124),\
(6127, 'Toledo', 124),\
(6128, 'Toro Pujio', 124),\
(6129, 'Tosno', 124),\
(6130, 'Tosquita', 124),\
(6131, 'Transito', 124),\
(6132, 'Tuclame', 124),\
(6133, 'Tutti', 124),\
(6134, 'Ucacha', 124),\
(6135, 'Unquillo', 124),\
(6136, 'Valle de Anisacate', 124),\
(6137, 'Valle Hermoso', 124),\
(6138, 'Velez Sarfield', 124),\
(6139, 'Viamonte', 124),\
(6140, 'Vicunia Mackenna', 124),\
(6141, 'Villa Allende', 124),\
(6142, 'Villa Amancay', 124),\
(6143, 'Villa Ascasubi', 124),\
(6144, 'Villa Candelaria N.', 124),\
(6145, 'Villa Carlos Paz', 124),\
(6146, 'Villa Cerro Azul', 124),\
(6147, 'Villa Ciudad de America', 124),\
(6148, 'Villa Ciudad Pque Los Reartes', 124),\
(6149, 'Villa Concepcion del Tio', 124),\
(6150, 'Villa Cura Brochero', 124),\
(6151, 'Villa de Las Rosas', 124),\
(6152, 'Villa de Maria', 124),\
(6153, 'Villa de Pocho', 124),\
(6154, 'Villa de Soto', 124),\
(6155, 'Villa del Dique', 124),\
(6156, 'Villa del Prado', 124),\
(6157, 'Villa del Rosario', 124),\
(6158, 'Villa del Totoral', 124),\
(6159, 'Villa Dolores', 124),\
(6160, 'Villa El Chancay', 124),\
(6161, 'Villa Elisa', 124),\
(6162, 'Villa Flor Serrana', 124),\
(6163, 'Villa Fontana', 124),\
(6164, 'Villa Giardino', 124),\
(6165, 'Villa Gral. Belgrano', 124),\
(6166, 'Villa Gutierrez', 124),\
(6167, 'Villa Huidobro', 124),\
(6168, 'Villa La Bolsa', 124),\
(6169, 'Villa Los Aromos', 124),\
(6170, 'Villa Los Patos', 124),\
(6171, 'Villa Maria', 124),\
(6172, 'Villa Nueva', 124),\
(6173, 'Villa Pque. Santa Ana', 124),\
(6174, 'Villa Pque. Siquiman', 124),\
(6175, 'Villa Quillinzo', 124),\
(6176, 'Villa Rossi', 124),\
(6177, 'Villa Rumipal', 124),\
(6178, 'Villa San Esteban', 124),\
(6179, 'Villa San Isidro', 124),\
(6180, 'Villa Santa Cruz', 124),\
(6181, 'Villa Sarmiento G.R', 124),\
(6182, 'Villa Sarmiento S.A', 124),\
(6183, 'Villa Tulumba', 124),\
(6184, 'Villa Valeria', 124),\
(6185, 'Villa Yacanto', 124),\
(6186, 'Washington', 124),\
(6187, 'Wenceslao Escalante', 124),\
(6188, 'Ycho Cruz Sierras', 124),\
(6189, 'Abdon Castro Tolay', 125),\
(6190, 'Abra Pampa', 125),\
(6191, 'Abralaite', 125),\
(6192, 'Aguas Calientes', 125),\
(6193, 'Arrayanal', 125),\
(6194, 'Barrios', 125),\
(6195, 'Caimancito', 125),\
(6196, 'Calilegua', 125),\
(6197, 'Cangrejillos', 125),\
(6198, 'Caspala', 125),\
(6199, 'Catua', 125),\
(6200, 'Cieneguillas', 125),\
(6201, 'Coranzulli', 125),\
(6202, 'Cusi-Cusi', 125),\
(6203, 'El Aguilar', 125),\
(6204, 'El Carmen', 125),\
(6205, 'El Condor', 125),\
(6206, 'El Fuerte', 125),\
(6207, 'El Piquete', 125),\
(6208, 'El Talar', 125),\
(6209, 'Fraile Pintado', 125),\
(6210, 'Hipolito Yrigoyen', 125),\
(6211, 'Huacalera', 125),\
(6212, 'Humahuaca', 125),\
(6213, 'La Esperanza', 125),\
(6214, 'La Mendieta', 125),\
(6215, 'La Quiaca', 125),\
(6216, 'Ledesma', 125),\
(6217, 'Libertador Gral. San Martin', 125),\
(6218, 'Maimara', 125),\
(6219, 'Mina Pirquitas', 125),\
(6220, 'Monterrico', 125),\
(6221, 'Palma Sola', 125),\
(6222, 'Palpala', 125),\
(6223, 'Pampa Blanca', 125),\
(6224, 'Pampichuela', 125),\
(6225, 'Perico', 125),\
(6226, 'Puesto del Marques', 125),\
(6227, 'Puesto Viejo', 125),\
(6228, 'Pumahuasi', 125),\
(6229, 'Purmamarca', 125),\
(6230, 'Rinconada', 125),\
(6231, 'Rodeitos', 125),\
(6232, 'Rosario de Rio Grande', 125),\
(6233, 'San Antonio', 125),\
(6234, 'San Francisco', 125),\
(6235, 'San Pedro', 125),\
(6236, 'San Rafael', 125),\
(6237, 'San Salvador', 125),\
(6238, 'Santa Ana', 125),\
(6239, 'Santa Catalina', 125),\
(6240, 'Santa Clara', 125),\
(6241, 'Susques', 125),\
(6242, 'Tilcara', 125),\
(6243, 'Tres Cruces', 125),\
(6244, 'Tumbaya', 125),\
(6245, 'Valle Grande', 125),\
(6246, 'Vinalito', 125),\
(6247, 'Volcan', 125),\
(6248, 'Yala', 125),\
(6249, 'Yavi', 125),\
(6250, 'Yuto', 125),\
(6251, 'Calafate', 126),\
(6252, 'Caleta Olivia', 126),\
(6253, 'Caniadon Seco', 126),\
(6254, 'Comandante Piedrabuena', 126),\
(6255, 'El Calafate', 126),\
(6256, 'El Chalten', 126),\
(6257, 'Gdor. Gregores', 126),\
(6258, 'Hipolito Yrigoyen', 126),\
(6259, 'Jaramillo', 126),\
(6260, 'Koluel Kaike', 126),\
(6261, 'Las Heras', 126),\
(6262, 'Los Antiguos', 126),\
(6263, 'Perito Moreno', 126),\
(6264, 'Pico Truncado', 126),\
(6265, 'Pto. Deseado', 126),\
(6266, 'Pto. San Julian', 126),\
(6267, 'Pto. Santa Cruz', 126),\
(6268, 'Rio Cuarto', 126),\
(6269, 'Rio Gallegos', 126),\
(6270, 'Rio Turbio', 126),\
(6271, 'Tres Lagos', 126),\
(6272, 'Veintiocho De Noviembre', 126),\
(6273, 'Agronomia', 127),\
(6274, 'Almagro', 127),\
(6275, 'Balvanera', 127),\
(6276, 'Barracas', 127),\
(6277, 'Belgrano', 127),\
(6278, 'Boca', 127),\
(6279, 'Boedo', 127),\
(6280, 'Caballito', 127),\
(6281, 'Chacarita', 127),\
(6282, 'Coghlan', 127),\
(6283, 'Colegiales', 127),\
(6284, 'Constitucion', 127),\
(6285, 'Flores', 127),\
(6286, 'Floresta', 127),\
(6287, 'La Paternal', 127),\
(6288, 'Liniers', 127),\
(6289, 'Mataderos', 127),\
(6290, 'Monserrat', 127),\
(6291, 'Monte Castro', 127),\
(6292, 'Nueva Pompeya', 127),\
(6293, 'Nuniez', 127),\
(6294, 'Palermo', 127),\
(6295, 'Parque Avellaneda', 127),\
(6296, 'Parque Chacabuco', 127),\
(6297, 'Parque Chas', 127),\
(6298, 'Parque Patricios', 127),\
(6299, 'Puerto Madero', 127),\
(6300, 'Recoleta', 127),\
(6301, 'Retiro', 127),\
(6302, 'Saavedra', 127),\
(6303, 'San Cristobal', 127),\
(6304, 'San Nicolas', 127),\
(6305, 'San Telmo', 127),\
(6306, 'Velez Sarsfield', 127),\
(6307, 'Versalles', 127),\
(6308, 'Villa Crespo', 127),\
(6309, 'Villa del Parque', 127),\
(6310, 'Villa Devoto', 127),\
(6311, 'Villa Gral. Mitre', 127),\
(6312, 'Villa Lugano', 127),\
(6313, 'Villa Luro', 127),\
(6314, 'Villa Ortuzar', 127),\
(6315, 'Villa Pueyrredon', 127),\
(6316, 'Villa Real', 127),\
(6317, 'Villa Riachuelo', 127),\
(6318, 'Villa Santa Rita', 127),\
(6319, 'Villa Soldati', 127),\
(6320, 'Villa Urquiza', 127);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `civil_status`\
--\
\
CREATE TABLE `civil_status` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `deleted_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `civil_status`\
--\
\
INSERT INTO `civil_status` (`id`, `name`, `deleted_at`) VALUES\
(1, 'Soltero(a)', NULL),\
(2, 'Casado(a)', NULL),\
(3, 'Viudo(a)', NULL),\
(4, 'Divorciado(a)', NULL),\
(5, 'En Convivencia Civil', NULL),\
(6, 'Otro', NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `communes`\
--\
\
CREATE TABLE `communes` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `city_id` int(10) UNSIGNED NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `communes`\
--\
\
INSERT INTO `communes` (`id`, `name`, `city_id`) VALUES\
(1, 'Arica', 1),\
(2, 'Camarones', 1),\
(3, 'General Lagos', 2),\
(4, 'Putre', 2),\
(5, 'Alto Hospicio', 3),\
(6, 'Iquique', 3),\
(7, 'Cami\'f1a', 4),\
(8, 'Colchane', 4),\
(9, 'Huara', 4),\
(10, 'Pica', 4),\
(11, 'Pozo Almonte', 4),\
(12, 'Antofagasta', 5),\
(13, 'Mejillones', 5),\
(14, 'Sierra Gorda', 5),\
(15, 'Taltal', 5),\
(16, 'Calama', 6),\
(17, 'Ollague', 6),\
(18, 'San Pedro de Atacama', 6),\
(19, 'Mar\'eda Elena', 7),\
(20, 'Tocopilla', 7),\
(21, 'Cha\'f1aral', 8),\
(22, 'Diego de Almagro', 8),\
(23, 'Caldera', 9),\
(24, 'Copiap\'f3', 9),\
(25, 'Tierra Amarilla', 9),\
(26, 'Alto del Carmen', 10),\
(27, 'Freirina', 10),\
(28, 'Huasco', 10),\
(29, 'Vallenar', 10),\
(30, 'Canela', 11),\
(31, 'Illapel', 11),\
(32, 'Los Vilos', 11),\
(33, 'Salamanca', 11),\
(34, 'Andacollo', 12),\
(35, 'Coquimbo', 12),\
(36, 'La Higuera', 12),\
(37, 'La Serena', 12),\
(38, 'Paihuaco', 12),\
(39, 'Vicu\'f1a', 12),\
(40, 'Combarbal\'e1', 13),\
(41, 'Monte Patria', 13),\
(42, 'Ovalle', 13),\
(43, 'Punitaqui', 13),\
(44, 'R\'edo Hurtado', 13),\
(45, 'Isla de Pascua', 14),\
(46, 'Calle Larga', 15),\
(47, 'Los Andes', 15),\
(48, 'Rinconada', 15),\
(49, 'San Esteban', 15),\
(50, 'La Ligua', 16),\
(51, 'Papudo', 16),\
(52, 'Petorca', 16),\
(53, 'Zapallar', 16),\
(54, 'Hijuelas', 17),\
(55, 'La Calera', 17),\
(56, 'La Cruz', 17),\
(57, 'Limache', 17),\
(58, 'Nogales', 17),\
(59, 'Olmu\'e9', 17),\
(60, 'Quillota', 17),\
(61, 'Algarrobo', 18),\
(62, 'Cartagena', 18),\
(63, 'El Quisco', 18),\
(64, 'El Tabo', 18),\
(65, 'San Antonio', 18),\
(66, 'Santo Domingo', 18),\
(67, 'Catemu', 19),\
(68, 'Llaillay', 19),\
(69, 'Panquehue', 19),\
(70, 'Putaendo', 19),\
(71, 'San Felipe', 19),\
(72, 'Santa Mar\'eda', 19),\
(73, 'Casablanca', 20),\
(74, 'Conc\'f3n', 20),\
(75, 'Juan Fern\'e1ndez', 20),\
(76, 'Puchuncav\'ed', 20),\
(77, 'Quilpu\'e9', 20),\
(78, 'Quintero', 20),\
(79, 'Valpara\'edso', 20),\
(80, 'Villa Alemana', 20),\
(81, 'Vi\'f1a del Mar', 20),\
(82, 'Colina', 21),\
(83, 'Lampa', 21),\
(84, 'Tiltil', 21),\
(85, 'Pirque', 22),\
(86, 'Puente Alto', 22),\
(87, 'San Jos\'e9 de Maipo', 22),\
(88, 'Buin', 23),\
(89, 'Calera de Tango', 23),\
(90, 'Paine', 23),\
(91, 'San Bernardo', 23),\
(92, 'Alhu\'e9', 24),\
(93, 'Curacav\'ed', 24),\
(94, 'Mar\'eda Pinto', 24),\
(95, 'Melipilla', 24),\
(96, 'San Pedro', 24),\
(97, 'Cerrillos', 25),\
(98, 'Cerro Navia', 25),\
(99, 'Conchal\'ed', 25),\
(100, 'El Bosque', 25),\
(101, 'Estaci\'f3n Central', 25),\
(102, 'Huechuraba', 25),\
(103, 'Independencia', 25),\
(104, 'La Cisterna', 25),\
(105, 'La Granja', 25),\
(106, 'La Florida', 25),\
(107, 'La Pintana', 25),\
(108, 'La Reina', 25),\
(109, 'Las Condes', 25),\
(110, 'Lo Barnechea', 25),\
(111, 'Lo Espejo', 25),\
(112, 'Lo Prado', 25),\
(113, 'Macul', 25),\
(114, 'Maip\'fa', 25),\
(115, '\'d1u\'f1oa', 25),\
(116, 'Pedro Aguirre Cerda', 25),\
(117, 'Pe\'f1alol\'e9n', 25),\
(118, 'Providencia', 25),\
(119, 'Pudahuel', 25),\
(120, 'Quilicura', 25),\
(121, 'Quinta Normal', 25),\
(122, 'Recoleta', 25),\
(123, 'Renca', 25),\
(124, 'San Miguel', 25),\
(125, 'San Joaqu\'edn', 25),\
(126, 'San Ram\'f3n', 25),\
(127, 'Santiago', 25),\
(128, 'Vitacura', 25),\
(129, 'El Monte', 26),\
(130, 'Isla de Maipo', 26),\
(131, 'Padre Hurtado', 26),\
(132, 'Pe\'f1aflor', 26),\
(133, 'Talagante', 26),\
(134, 'Codegua', 27),\
(135, 'Co\'ednco', 27),\
(136, 'Coltauco', 27),\
(137, 'Do\'f1ihue', 27),\
(138, 'Graneros', 27),\
(139, 'Las Cabras', 27),\
(140, 'Machal\'ed', 27),\
(141, 'Malloa', 27),\
(142, 'Mostazal', 27),\
(143, 'Olivar', 27),\
(144, 'Peumo', 27),\
(145, 'Pichidegua', 27),\
(146, 'Quinta de Tilcoco', 27),\
(147, 'Rancagua', 27),\
(148, 'Rengo', 27),\
(149, 'Requ\'ednoa', 27),\
(150, 'San Vicente de Tagua Tagua', 27),\
(151, 'La Estrella', 28),\
(152, 'Litueche', 28),\
(153, 'Marchihue', 28),\
(154, 'Navidad', 28),\
(155, 'Peredones', 28),\
(156, 'Pichilemu', 28),\
(157, 'Ch\'e9pica', 29),\
(158, 'Chimbarongo', 29),\
(159, 'Lolol', 29),\
(160, 'Nancagua', 29),\
(161, 'Palmilla', 29),\
(162, 'Peralillo', 29),\
(163, 'Placilla', 29),\
(164, 'Pumanque', 29),\
(165, 'San Fernando', 29),\
(166, 'Santa Cruz', 29),\
(167, 'Cauquenes', 30),\
(168, 'Chanco', 30),\
(169, 'Pelluhue', 30),\
(170, 'Curic\'f3', 31),\
(171, 'Huala\'f1\'e9', 31),\
(172, 'Licant\'e9n', 31),\
(173, 'Molina', 31),\
(174, 'Rauco', 31),\
(175, 'Romeral', 31),\
(176, 'Sagrada Familia', 31),\
(177, 'Teno', 31),\
(178, 'Vichuqu\'e9n', 31),\
(179, 'Colb\'fan', 32),\
(180, 'Linares', 32),\
(181, 'Longav\'ed', 32),\
(182, 'Parral', 32),\
(183, 'Retiro', 32),\
(184, 'San Javier', 32),\
(185, 'Villa Alegre', 32),\
(186, 'Yerbas Buenas', 32),\
(187, 'Constituci\'f3n', 33),\
(188, 'Curepto', 33),\
(189, 'Empedrado', 33),\
(190, 'Maule', 33),\
(191, 'Pelarco', 33),\
(192, 'Pencahue', 33),\
(193, 'R\'edo Claro', 33),\
(194, 'San Clemente', 33),\
(195, 'San Rafael', 33),\
(196, 'Talca', 33),\
(197, 'Arauco', 34),\
(198, 'Ca\'f1ete', 34),\
(199, 'Contulmo', 34),\
(200, 'Curanilahue', 34),\
(201, 'Lebu', 34),\
(202, 'Los \'c1lamos', 34),\
(203, 'Tir\'faa', 34),\
(204, 'Alto Biob\'edo', 35),\
(205, 'Antuco', 35),\
(206, 'Cabrero', 35),\
(207, 'Laja', 35),\
(208, 'Los \'c1ngeles', 35),\
(209, 'Mulch\'e9n', 35),\
(210, 'Nacimiento', 35),\
(211, 'Negrete', 35),\
(212, 'Quilaco', 35),\
(213, 'Quilleco', 35),\
(214, 'San Rosendo', 35),\
(215, 'Santa B\'e1rbara', 35),\
(216, 'Tucapel', 35),\
(217, 'Yumbel', 35),\
(218, 'Chiguayante', 36),\
(219, 'Concepci\'f3n', 36),\
(220, 'Coronel', 36),\
(221, 'Florida', 36),\
(222, 'Hualp\'e9n', 36),\
(223, 'Hualqui', 36),\
(224, 'Lota', 36),\
(225, 'Penco', 36),\
(226, 'San Pedro de La Paz', 36),\
(227, 'Santa Juana', 36),\
(228, 'Talcahuano', 36),\
(229, 'Tom\'e9', 36),\
(230, 'Bulnes', 37),\
(231, 'Chill\'e1n', 37),\
(232, 'Chill\'e1n Viejo', 37),\
(233, 'Cobquecura', 37),\
(234, 'Coelemu', 37),\
(235, 'Coihueco', 37),\
(236, 'El Carmen', 37),\
(237, 'Ninhue', 37),\
(238, '\'d1iquen', 37),\
(239, 'Pemuco', 37),\
(240, 'Pinto', 37),\
(241, 'Portezuelo', 37),\
(242, 'Quill\'f3n', 37),\
(243, 'Quirihue', 37),\
(244, 'R\'e1nquil', 37),\
(245, 'San Carlos', 37),\
(246, 'San Fabi\'e1n', 37),\
(247, 'San Ignacio', 37),\
(248, 'San Nicol\'e1s', 37),\
(249, 'Treguaco', 37),\
(250, 'Yungay', 37),\
(251, 'Carahue', 38),\
(252, 'Cholchol', 38),\
(253, 'Cunco', 38),\
(254, 'Curarrehue', 38),\
(255, 'Freire', 38),\
(256, 'Galvarino', 38),\
(257, 'Gorbea', 38),\
(258, 'Lautaro', 38),\
(259, 'Loncoche', 38),\
(260, 'Melipeuco', 38),\
(261, 'Nueva Imperial', 38),\
(262, 'Padre Las Casas', 38),\
(263, 'Perquenco', 38),\
(264, 'Pitrufqu\'e9n', 38),\
(265, 'Puc\'f3n', 38),\
(266, 'Saavedra', 38),\
(267, 'Temuco', 38),\
(268, 'Teodoro Schmidt', 38),\
(269, 'Tolt\'e9n', 38),\
(270, 'Vilc\'fan', 38),\
(271, 'Villarrica', 38),\
(272, 'Angol', 39),\
(273, 'Collipulli', 39),\
(274, 'Curacaut\'edn', 39),\
(275, 'Ercilla', 39),\
(276, 'Lonquimay', 39),\
(277, 'Los Sauces', 39),\
(278, 'Lumaco', 39),\
(279, 'Pur\'e9n', 39),\
(280, 'Renaico', 39),\
(281, 'Traigu\'e9n', 39),\
(282, 'Victoria', 39),\
(283, 'Corral', 40),\
(284, 'Lanco', 40),\
(285, 'Los Lagos', 40),\
(286, 'M\'e1fil', 40),\
(287, 'Mariquina', 40),\
(288, 'Paillaco', 40),\
(289, 'Panguipulli', 40),\
(290, 'Valdivia', 40),\
(291, 'Futrono', 41),\
(292, 'La Uni\'f3n', 41),\
(293, 'Lago Ranco', 41),\
(294, 'R\'edo Bueno', 41),\
(295, 'Ancud', 42),\
(296, 'Castro', 42),\
(297, 'Chonchi', 42),\
(298, 'Curaco de V\'e9lez', 42),\
(299, 'Dalcahue', 42),\
(300, 'Puqueld\'f3n', 42),\
(301, 'Queil\'e9n', 42),\
(302, 'Quemchi', 42),\
(303, 'Quell\'f3n', 42),\
(304, 'Quinchao', 42),\
(305, 'Calbuco', 43),\
(306, 'Cocham\'f3', 43),\
(307, 'Fresia', 43),\
(308, 'Frutillar', 43),\
(309, 'Llanquihue', 43),\
(310, 'Los Muermos', 43),\
(311, 'Maull\'edn', 43),\
(312, 'Puerto Montt', 43),\
(313, 'Puerto Varas', 43),\
(314, 'Osorno', 44),\
(315, 'Puero Octay', 44),\
(316, 'Purranque', 44),\
(317, 'Puyehue', 44),\
(318, 'R\'edo Negro', 44),\
(319, 'San Juan de la Costa', 44),\
(320, 'San Pablo', 44),\
(321, 'Chait\'e9n', 45),\
(322, 'Futaleuf\'fa', 45),\
(323, 'Hualaihu\'e9', 45),\
(324, 'Palena', 45),\
(325, 'Ais\'e9n', 46),\
(326, 'Cisnes', 46),\
(327, 'Guaitecas', 46),\
(328, 'Cochrane', 47),\
(329, 'O\\'higgins', 47),\
(330, 'Tortel', 47),\
(331, 'Coihaique', 48),\
(332, 'Lago Verde', 48),\
(333, 'Chile Chico', 49),\
(334, 'R\'edo Ib\'e1\'f1ez', 49),\
(335, 'Ant\'e1rtica', 50),\
(336, 'Cabo de Hornos', 50),\
(337, 'Laguna Blanca', 51),\
(338, 'Punta Arenas', 51),\
(339, 'R\'edo Verde', 51),\
(340, 'San Gregorio', 51),\
(341, 'Porvenir', 52),\
(342, 'Primavera', 52),\
(343, 'Timaukel', 52),\
(344, 'Natales', 53),\
(345, 'Torres del Paine', 53);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `companies`\
--\
\
CREATE TABLE `companies` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `cell_phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `website` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `rut` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `giro` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `description` text COLLATE utf8mb4_unicode_ci,\
  `type` tinyint(1) DEFAULT NULL,\
  `invoice` tinyint(1) DEFAULT NULL,\
  `personal_publish` tinyint(1) DEFAULT '0',\
  `sii` tinyint(1) DEFAULT NULL,\
  `address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `address_details` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `latitude` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `longitude` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `personal_address` tinyint(1) DEFAULT '0',\
  `user_id` int(10) UNSIGNED DEFAULT NULL,\
  `city_id` int(10) UNSIGNED DEFAULT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `companies`\
--\
\
INSERT INTO `companies` (`id`, `name`, `phone`, `cell_phone`, `website`, `email`, `rut`, `giro`, `description`, `type`, `invoice`, `personal_publish`, `sii`, `address`, `address_details`, `latitude`, `longitude`, `personal_address`, `user_id`, `city_id`, `created_at`, `updated_at`) VALUES\
(1, 'Swift LLC', '315-739-6147 x386', '+1 (650) 518-4094', 'skiles.com', 'felicity.christiansen@miller.com', NULL, NULL, 'Aspernatur dignissimos provident corporis alias ratione veritatis quo aliquid.', 0, 0, 1, 0, 'Totam perspiciatis sed rerum enim nemo asperiores.', 'Tenetur nobis in minus deserunt quam rem.', NULL, NULL, 0, 4, 2058, NULL, NULL),\
(2, 'Ritchie PLC', '+1-696-989-7034', '+15316071952', 'ritchie.info', 'trevion51@huel.com', NULL, NULL, 'Pariatur quasi consequatur et et tempora.', 0, 0, 0, 0, 'Delectus ipsum perferendis maiores provident ipsum officiis.', 'Aut illum illum placeat.', NULL, NULL, 1, 7, 1986, NULL, NULL),\
(3, 'Nienow, Ondricka and Frami', '1-478-808-0815 x684', '720-716-1143 x1554', 'botsford.info', 'hhowe@blanda.com', NULL, NULL, 'Natus dolores quae ut facilis inventore nihil.', 0, 1, 0, 0, 'Dolorum qui commodi error quaerat quia dignissimos.', 'Praesentium ea quas laborum et.', NULL, NULL, 1, 8, 4205, NULL, NULL),\
(4, 'Kiehn-Kilback', '(819) 640-0270 x000', '618.938.6316 x784', 'greenholt.com', 'gleason.gordon@flatley.com', NULL, NULL, 'Expedita cumque sit omnis numquam vel modi voluptas.', 1, 1, 0, 1, 'Nemo molestiae iste ut numquam ab et quos quaerat.', 'Rem ab deserunt non magnam iusto.', NULL, NULL, 0, 8, 242, NULL, NULL),\
(5, 'Smitham-Rogahn', '+13425991189', '859.284.2552 x81976', 'sipes.com', 'bria.carroll@feeney.com', NULL, NULL, 'Sit blanditiis voluptates ducimus aut sit ullam.', 0, 1, 1, 1, 'Esse sint dolor ratione impedit.', 'Nulla magni et omnis esse sunt sed.', NULL, NULL, 0, 5, 3538, NULL, NULL),\
(6, 'Hessel-Crooks', '1-536-866-5830', '1-859-464-6403 x91019', 'bruen.com', 'lindgren.lupe@cassin.com', NULL, NULL, 'Consectetur quia odit eveniet sunt quae.', 0, 1, 1, 1, 'Aut libero quo repellendus.', 'Ratione deleniti quasi dicta.', NULL, NULL, 1, 10, 1068, NULL, NULL),\
(7, 'Pouros, Hyatt and Bauch', '1-267-476-0318 x48773', '274-599-9821', 'lynch.com', 'bernadine.conn@runte.com', NULL, NULL, 'Saepe sit maiores necessitatibus a illo quis in.', 1, 1, 1, 1, 'Voluptates mollitia sunt consequuntur repudiandae odio in.', 'Dolores officia id et autem perspiciatis.', NULL, NULL, 1, 8, 3848, NULL, NULL),\
(8, 'Hill-Robel', '763-346-1157', '349.451.5203', 'conroy.info', 'yrice@gorczany.com', NULL, NULL, 'Sint cumque est quo iure eligendi consectetur minus cum.', 0, 0, 0, 1, 'Nulla assumenda ratione a temporibus esse.', 'Non vitae quia mollitia omnis.', NULL, NULL, 0, 5, 1504, NULL, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `companies_has_services_list`\
--\
\
CREATE TABLE `companies_has_services_list` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `company_id` int(10) UNSIGNED NOT NULL,\
  `service_list_id` int(10) UNSIGNED NOT NULL,\
  `description` text COLLATE utf8mb4_unicode_ci,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `companies_has_services_list`\
--\
\
INSERT INTO `companies_has_services_list` (`id`, `company_id`, `service_list_id`, `description`, `created_at`, `updated_at`) VALUES\
(1, 1, 2, NULL, NULL, NULL),\
(2, 1, 5, NULL, NULL, NULL),\
(3, 1, 1, NULL, NULL, NULL),\
(4, 2, 6, NULL, NULL, NULL),\
(5, 2, 3, NULL, NULL, NULL),\
(6, 2, 7, NULL, NULL, NULL),\
(7, 3, 4, NULL, NULL, NULL),\
(8, 3, 3, NULL, NULL, NULL),\
(9, 3, 8, NULL, NULL, NULL),\
(10, 4, 6, NULL, NULL, NULL),\
(11, 4, 2, NULL, NULL, NULL),\
(12, 4, 4, NULL, NULL, NULL),\
(13, 5, 6, NULL, NULL, NULL),\
(14, 5, 4, NULL, NULL, NULL),\
(15, 5, 3, NULL, NULL, NULL),\
(16, 6, 1, NULL, NULL, NULL),\
(17, 6, 7, NULL, NULL, NULL),\
(18, 6, 1, NULL, NULL, NULL),\
(19, 7, 5, NULL, NULL, NULL),\
(20, 7, 5, NULL, NULL, NULL),\
(21, 7, 3, NULL, NULL, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `configurations`\
--\
\
CREATE TABLE `configurations` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `title` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `enabled` tinyint(1) NOT NULL DEFAULT '1',\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `configurations`\
--\
\
INSERT INTO `configurations` (`id`, `name`, `title`, `enabled`, `created_at`, `updated_at`) VALUES\
(1, 'phone-verify', 'Registro de usuario con verificaci\'f3n de telefono', 1, NULL, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `contact_messages`\
--\
\
CREATE TABLE `contact_messages` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `reason_contact` tinyint(4) NOT NULL,\
  `message` text COLLATE utf8mb4_unicode_ci,\
  `created_at` datetime DEFAULT NULL,\
  `updated_at` datetime DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `contracts`\
--\
\
CREATE TABLE `contracts` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `property_id` int(10) UNSIGNED NOT NULL,\
  `active` tinyint(1) NOT NULL DEFAULT '1',\
  `signature_request_id_hs` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `is_complete` tinyint(1) NOT NULL DEFAULT '0',\
  `has_error` tinyint(1) NOT NULL DEFAULT '0',\
  `files_url_hs` text COLLATE utf8mb4_unicode_ci,\
  `signing_url_hs` text COLLATE utf8mb4_unicode_ci,\
  `details_url_hs` text COLLATE utf8mb4_unicode_ci,\
  `allow_reassign_hs` tinyint(1) NOT NULL DEFAULT '0',\
  `title_hs` text COLLATE utf8mb4_unicode_ci,\
  `subject_hs` text COLLATE utf8mb4_unicode_ci,\
  `message_hs` text COLLATE utf8mb4_unicode_ci,\
  `path_file` text COLLATE utf8mb4_unicode_ci,\
  `path_file_pre` text COLLATE utf8mb4_unicode_ci,\
  `allow_decline` tinyint(1) NOT NULL DEFAULT '0',\
  `is_declined` tinyint(1) NOT NULL DEFAULT '0',\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `conversations`\
--\
\
CREATE TABLE `conversations` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `user_id` int(10) UNSIGNED NOT NULL,\
  `contact_id` int(10) UNSIGNED NOT NULL,\
  `last_message` text COLLATE utf8mb4_unicode_ci,\
  `last_time` datetime DEFAULT NULL,\
  `listen_notifications` tinyint(1) NOT NULL DEFAULT '1',\
  `has_blocked` tinyint(1) NOT NULL DEFAULT '0',\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `conversations`\
--\
\
INSERT INTO `conversations` (`id`, `user_id`, `contact_id`, `last_message`, `last_time`, `listen_notifications`, `has_blocked`, `created_at`, `updated_at`) VALUES\
(1, 1, 2, 'Jose: Bien, gracias. Y tu? Ok, hablemos de ello.', '2020-01-20 16:12:34', 1, 0, '2020-01-21 00:12:33', '2020-01-21 00:12:34'),\
(2, 1, 3, 'Hannah: igual para t\'ed. Que tal? Si, revisa la publicaci\'f3n, ya actualic\'e9 las fotos con la vista pedida, para que puedas verlas.', '2020-01-20 16:12:34', 1, 0, '2020-01-21 00:12:33', '2020-01-21 00:12:34'),\
(3, 2, 1, 'T\'fa: Bien, gracias. Y tu? Ok, hablemos de ello.', '2020-01-20 16:12:34', 1, 0, '2020-01-21 00:12:33', '2020-01-21 00:12:34'),\
(4, 3, 1, 'T\'fa: igual para t\'ed. Que tal? Si, revisa la publicaci\'f3n, ya actualic\'e9 las fotos con la vista pedida, para que puedas verlas.', '2020-01-20 16:12:34', 1, 0, '2020-01-21 00:12:33', '2020-01-21 00:12:34');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `countries`\
--\
\
CREATE TABLE `countries` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `nationality` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',\
  `valid` tinyint(1) NOT NULL DEFAULT '0',\
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `countries`\
--\
\
INSERT INTO `countries` (`id`, `name`, `nationality`, `valid`, `code`) VALUES\
(1, 'Afganist\'e1n', 'Afgana', 0, 'AFG'),\
(2, 'Albania', 'Alban\'e9s', 0, 'ALB'),\
(3, 'Alemania', 'Alemana', 0, 'DEU'),\
(4, 'Andorra', '', 0, 'AND'),\
(5, 'Angola', '', 0, 'AGO'),\
(6, 'AntiguayBarbuda', '', 0, 'ATG'),\
(7, 'ArabiaSaudita', 'Saud\'ed', 0, 'SAU'),\
(8, 'Argelia', '', 0, 'DZA'),\
(9, 'Argentina', 'Argentina', 0, 'ARG'),\
(10, 'Armenia', '', 0, 'ARM'),\
(11, 'Aruba', '', 0, 'ABW'),\
(12, 'Australia', 'Australiana', 0, 'AUS'),\
(13, 'Austria', 'Austr\'edaca', 0, 'AUT'),\
(14, 'Azerbaiy\'e1n', '', 0, 'AZE'),\
(15, 'Bahamas', '', 0, 'BHS'),\
(16, 'Banglad\'e9s', '', 0, 'BGD'),\
(17, 'Barbados', '', 0, 'BRB'),\
(18, 'Bar\'e9in', '', 0, 'BHR'),\
(19, 'B\'e9lgica', 'Belga', 0, 'BEL'),\
(20, 'Belice', '', 0, 'BLZ'),\
(21, 'Ben\'edn', '', 0, 'BEN'),\
(22, 'Bielorrusia', '', 0, 'BLR'),\
(23, 'Birmania', '', 0, 'MMR'),\
(24, 'Bolivia', 'Boliviana', 0, 'BOL'),\
(25, 'BosniayHerzegovina', '', 0, 'BIH'),\
(26, 'Botsuana', '', 0, 'BWA'),\
(27, 'Brasil', 'Brasile\'f1a', 0, 'BRA'),\
(28, 'Brun\'e9i', '', 0, 'BRN'),\
(29, 'Bulgaria', '', 0, 'BGR'),\
(30, 'BurkinaFaso', '', 0, 'BFA'),\
(31, 'Burundi', '', 0, 'BDI'),\
(32, 'But\'e1n', '', 0, 'BTN'),\
(33, 'CaboVerde', '', 0, 'CPV'),\
(34, 'Camboya', '', 0, 'KHM'),\
(35, 'Camer\'fan', '', 0, 'CMR'),\
(36, 'Canad\'e1', 'Canadiense', 0, 'CAN'),\
(37, 'Catar', '', 0, 'QAT'),\
(38, 'Chad', '', 0, 'TCD'),\
(39, 'Chile', 'Chilena', 1, 'CHL'),\
(40, 'China', 'China', 0, 'CHN'),\
(41, 'Chipre', '', 0, 'CYP'),\
(42, 'CiudaddelVaticano', '', 0, 'VAT'),\
(43, 'Colombia', 'Colombiana', 0, 'COL'),\
(44, 'Comoras', '', 0, 'COM'),\
(45, 'CoreadelNorte', 'Nor Coreana', 0, 'PRK'),\
(46, 'CoreadelSur', 'Sud Coreana', 0, 'KOR'),\
(47, 'CostadeMarfil', 'Marfile\'f1a', 0, 'CIV'),\
(48, 'CostaRica', 'Costa Riquense', 0, 'CRI'),\
(49, 'Croacia', '', 0, 'HRV'),\
(50, 'Cuba', 'Cubana', 0, 'CUB'),\
(51, 'Dinamarca', 'Danesa', 0, 'DNK'),\
(52, 'Dominica', '', 0, 'DMA'),\
(53, 'Ecuador', 'Ecuatoriana', 0, 'ECU'),\
(54, 'Egipto', 'Egipcia', 0, 'EGY'),\
(55, 'ElSalvador', 'Salvadore\'f1a', 0, 'SLV'),\
(56, 'Emiratos\'c1rabesUnidos', '', 0, 'ARE'),\
(57, 'Eritrea', '', 0, 'ERI'),\
(58, 'Eslovaquia', '', 0, 'SVK'),\
(59, 'Eslovenia', '', 0, 'SVN'),\
(60, 'Espa\'f1a', 'Espa\'f1ola', 0, 'ESP'),\
(61, 'EstadosUnidos', 'Americana', 0, 'USA'),\
(62, 'Estonia', '', 0, 'EST'),\
(63, 'Etiop\'eda', '', 0, 'ETH'),\
(64, 'Filipinas', '', 0, 'PHL'),\
(65, 'Finlandia', 'Finlandesa', 0, 'FIN'),\
(66, 'Fiyi', '', 0, 'FJI'),\
(67, 'Francia', 'Francesa', 0, 'FRA'),\
(68, 'Gab\'f3n', '', 0, 'GAB'),\
(69, 'Gambia', '', 0, 'GMB'),\
(70, 'Georgia', '', 0, 'GEO'),\
(71, 'Gibraltar', '', 0, 'GIB'),\
(72, 'Ghana', '', 0, 'GHA'),\
(73, 'Granada', '', 0, 'GRD'),\
(74, 'Grecia', '', 0, 'GRC'),\
(75, 'Groenlandia', '', 0, 'GRL'),\
(76, 'Guatemala', 'Guatemalteca', 0, 'GTM'),\
(77, 'Guineaecuatorial', '', 0, 'GNQ'),\
(78, 'Guinea', '', 0, 'GIN'),\
(79, 'Guinea-Bis\'e1u', '', 0, 'GNB'),\
(80, 'Guyana', '', 0, 'GUY'),\
(81, 'Hait\'ed', 'Haitiana', 0, 'HTI'),\
(82, 'Honduras', 'Hondure\'f1a', 0, 'HND'),\
(83, 'Hungr\'eda', '', 0, 'HUN'),\
(84, 'India', 'India', 0, 'IND'),\
(85, 'Indonesia', '', 0, 'IDN'),\
(86, 'Irak', 'Iraqu\'ed', 0, 'IRQ'),\
(87, 'Ir\'e1n', 'Iran\'ed', 0, 'IRN'),\
(88, 'Irlanda', '', 0, 'IRL'),\
(89, 'Islandia', '', 0, 'ISL'),\
(90, 'IslasCook', '', 0, 'COK'),\
(91, 'IslasMarshall', '', 0, 'MHL'),\
(92, 'IslasSalom\'f3n', '', 0, 'SLB'),\
(93, 'Israel', 'Isrrael\'ed', 0, 'ISR'),\
(94, 'Italia', 'It\'e1lica', 0, 'ITA'),\
(95, 'Jamaica', '', 0, 'JAM'),\
(96, 'Jap\'f3n', 'Japonesa', 0, 'JPN'),\
(97, 'Jordania', '', 0, 'JOR'),\
(98, 'Kazajist\'e1n', '', 0, 'KAZ'),\
(99, 'Kenia', '', 0, 'KEN'),\
(100, 'Kirguist\'e1n', '', 0, 'KGZ'),\
(101, 'Kiribati', '', 0, 'KIR'),\
(102, 'Kuwait', '', 0, 'KWT'),\
(103, 'Laos', '', 0, 'LAO'),\
(104, 'Lesoto', '', 0, 'LSO'),\
(105, 'Letonia', '', 0, 'LVA'),\
(106, 'L\'edbano', '', 0, 'LBN'),\
(107, 'Liberia', '', 0, 'LBR'),\
(108, 'Libia', '', 0, 'LBY'),\
(109, 'Liechtenstein', '', 0, 'LIE'),\
(110, 'Lituania', '', 0, 'LTU'),\
(111, 'Luxemburgo', '', 0, 'LUX'),\
(112, 'Madagascar', '', 0, 'MDG'),\
(113, 'Malasia', '', 0, 'MYS'),\
(114, 'Malaui', '', 0, 'MWI'),\
(115, 'Maldivas', '', 0, 'MDV'),\
(116, 'Mal\'ed', '', 0, 'MLI'),\
(117, 'Malta', '', 0, 'MLT'),\
(118, 'Marruecos', '', 0, 'MAR'),\
(119, 'Martinica', '', 0, 'MTQ'),\
(120, 'Mauricio', '', 0, 'MUS'),\
(121, 'Mauritania', '', 0, 'MRT'),\
(122, 'M\'e9xico', 'Mexicana', 0, 'MEX'),\
(123, 'Micronesia', '', 0, 'FSM'),\
(124, 'Moldavia', '', 0, 'MDA'),\
(125, 'M\'f3naco', '', 0, 'MCO'),\
(126, 'Mongolia', '', 0, 'MNG'),\
(127, 'Montenegro', '', 0, 'MNE'),\
(128, 'Mozambique', '', 0, 'MOZ'),\
(129, 'Namibia', '', 0, 'NAM'),\
(130, 'Nauru', '', 0, 'NRU'),\
(131, 'Nepal', '', 0, 'NPL'),\
(132, 'Nicaragua', 'Nicaraguense', 0, 'NIC'),\
(133, 'N\'edger', '', 0, 'NER'),\
(134, 'Nigeria', '', 0, 'NGA'),\
(135, 'Noruega', 'Noruega', 0, 'NOR'),\
(136, 'NuevaZelanda', '', 0, 'NZL'),\
(137, 'Om\'e1n', '', 0, 'OMN'),\
(138, 'Pa\'edsesBajos', 'Holandesa', 0, 'NLD'),\
(139, 'Pakist\'e1n', '', 0, 'PAK'),\
(140, 'Palaos', '', 0, 'PLW'),\
(141, 'Palestina', 'Palestina', 0, 'PSE'),\
(142, 'Panam\'e1', 'Paname\'f1a', 0, 'PAN'),\
(143, 'Pap\'faaNuevaGuinea', '', 0, 'PNG'),\
(144, 'Paraguay', '', 0, 'PRY'),\
(145, 'Per\'fa', 'Peruana', 0, 'PER'),\
(146, 'Polonia', '', 0, 'POL'),\
(147, 'Portugal', 'Portuguesa', 0, 'PRT'),\
(148, 'PuertoRico', 'Puerto Riquense', 0, 'PRI'),\
(149, 'ReinoUnido', 'Brit\'e1nica', 0, 'GBR'),\
(150, 'Rep\'fablicaCentroafricana', '', 0, 'CAF'),\
(151, 'Rep\'fablicaCheca', 'Checa', 0, 'CZE'),\
(152, 'Rep\'fablicadeMacedonia', '', 0, 'MKD'),\
(153, 'Rep\'fablicadelCongo', '', 0, 'COG'),\
(154, 'Rep\'fablicaDemocr\'e1ticadelCongo', '', 0, 'COD'),\
(155, 'Rep\'fablicaDominicana', 'Dominicana', 0, 'DOM'),\
(156, 'Sud\'e1frica', '', 0, 'ZAF'),\
(157, 'Ruanda', '', 0, 'RWA'),\
(158, 'Ruman\'eda', '', 0, 'ROU'),\
(159, 'Rusia', 'Rusa', 0, 'RUS'),\
(160, 'Samoa', '', 0, 'WSM'),\
(161, 'SanCrist\'f3balyNieves', '', 0, 'KNA'),\
(162, 'SanMarino', '', 0, 'SMR'),\
(163, 'SanVicenteylasGranadinas', '', 0, 'VCT'),\
(164, 'SantaLuc\'eda', '', 0, 'LCA'),\
(165, 'SantoTom\'e9yPr\'edncipe', '', 0, 'STP'),\
(166, 'Senegal', '', 0, 'SEN'),\
(167, 'Serbia', '', 0, 'SRB'),\
(168, 'Seychelles', '', 0, 'SYC'),\
(169, 'SierraLeona', '', 0, 'SLE'),\
(170, 'Singapur', '', 0, 'SGP'),\
(171, 'Siria', '', 0, 'SYR'),\
(172, 'Somalia', '', 0, 'SOM'),\
(173, 'SriLanka', '', 0, 'LKA'),\
(174, 'Suazilandia', '', 0, 'SWZ'),\
(175, 'Sud\'e1ndelSur', '', 0, 'SSD'),\
(176, 'Sud\'e1n', '', 0, 'SDN'),\
(177, 'Suecia', '', 0, 'SWE'),\
(178, 'Suiza', '', 0, 'CHE'),\
(179, 'Surinam', '', 0, 'SUR'),\
(180, 'Tailandia', '', 0, 'THA'),\
(181, 'Tanzania', '', 0, 'TZA'),\
(182, 'Tayikist\'e1n', '', 0, 'TJK'),\
(183, 'TimorOriental', '', 0, 'TLS'),\
(184, 'Togo', '', 0, 'TGO'),\
(185, 'Tonga', '', 0, 'TON'),\
(186, 'TrinidadyTobago', '', 0, 'TTO'),\
(187, 'T\'fanez', '', 0, 'TUN'),\
(188, 'Turkmenist\'e1n', '', 0, 'TKM'),\
(189, 'Turqu\'eda', '', 0, 'TUR'),\
(190, 'Tuvalu', '', 0, 'TUV'),\
(191, 'Ucrania', '', 0, 'UKR'),\
(192, 'Uganda', '', 0, 'UGA'),\
(193, 'Uruguay', 'Uruguaya', 0, 'URY'),\
(194, 'Uzbekist\'e1n', '', 0, 'UZB'),\
(195, 'Vanuatu', '', 0, 'VUT'),\
(196, 'Venezuela', 'Venezolana', 0, 'VEN'),\
(197, 'Vietnam', '', 0, 'VNM'),\
(198, 'Yemen', '', 0, 'YEM'),\
(199, 'Yibuti', '', 0, 'DJI'),\
(200, 'Zambia', '', 0, 'ZMB'),\
(201, 'Zimbabue', '', 0, 'ZWE');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `coupons`\
--\
\
CREATE TABLE `coupons` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `membership_id` int(10) UNSIGNED NOT NULL,\
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `enabled` tinyint(1) DEFAULT NULL,\
  `expires_at` date DEFAULT NULL,\
  `quantity` int(11) DEFAULT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `det_scoring`\
--\
\
CREATE TABLE `det_scoring` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `cat_scoring_id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',\
  `description` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',\
  `feed_back` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',\
  `points` int(11) NOT NULL DEFAULT '0',\
  `method` tinyint(1) NOT NULL DEFAULT '0'\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `det_scoring`\
--\
\
INSERT INTO `det_scoring` (`id`, `cat_scoring_id`, `name`, `description`, `feed_back`, `points`, `method`) VALUES\
(1, 1, 'Tel\'e9fono', 'Scoring Validaci\'f3n de Tel\'e9fono', 'Retroalimentaci\'f3n para Tel\'e9fono', 25, 0),\
(2, 1, 'Correo ', 'Scoring Validaci\'f3n de Validaci\'f3n de Correo', 'Retroalimentaci\'f3n para Validaci\'f3n de Correo', 25, 0),\
(3, 1, 'Identidad DNI Frontal', 'Scoring de Identidad DNI Frontal', 'Retroalimentaci\'f3n para Identidad DNI Frontal', 15, 0),\
(4, 1, 'Identidad DNI Lateral', 'Scoring de Identidad DNI Lateral', 'Retroalimentaci\'f3n para Identidad DNI Lateral', 15, 0),\
(5, 1, 'Nacional', 'Scoring de Nacional', 'Retroalimentaci\'f3n para Nacional', 50, 0),\
(6, 1, 'Nacional con RUT', 'Scoring de Nacional con RUT', 'Retroalimentaci\'f3n para Nacional con RUT', 50, 0),\
(7, 1, 'Nacional con RUT Provisional', 'Scoring de Nacional con RUT Provisional', 'Retroalimentaci\'f3n para Nacional con RUT Provisional', 30, 0),\
(8, 1, 'Pasaporte', 'Scoring de Pasaporte', 'Retroalimentaci\'f3n para Pasaporte', 20, 0),\
(9, 2, 'Confirmaci\'f3n  de Aval', 'Scoring Confirmaci\'f3n de Aval', 'Retroalimentaci\'f3n para  Confirmaci\'f3n de Aval', 100, 0),\
(10, 2, ' Sin Confirmaci\'f3n  de Aval', 'Scoring Sin Confirmaci\'f3n de Aval', 'Retroalimentaci\'f3n para  Sin Confirmaci\'f3n de Aval', 50, 0),\
(11, 2, 'Seguro de Arriendo ', 'Scoring de Seguro de Arriendo', 'Retroalimentaci\'f3n para Seguro de Arriendo', 100, 0),\
(12, 2, 'Tel\'e9fono Aval', 'Scoring Validaci\'f3n de Tel\'e9fono Aval', 'Retroalimentaci\'f3n para Tel\'e9fono Aval', 25, 0),\
(13, 2, 'Correo Aval', 'Scoring  Validaci\'f3n de Correo Aval', 'Retroalimentaci\'f3n para Validaci\'f3n de Correo Aval', 25, 0),\
(14, 2, 'Identidad DNI Frontal -Aval', 'Scoring de Identidad DNI Frontal-Aval', 'Retroalimentaci\'f3n para Identidad DNI Frontal-Aval', 15, 0),\
(15, 2, 'Identidad DNI Lateral -Aval', 'Scoring de Identidad DNI Lateral-Aval', 'Retroalimentaci\'f3n para Identidad DNI Lateral-Aval', 15, 0),\
(16, 2, 'Nacional-Aval', 'Scoring de Nacional-Aval', 'Retroalimentaci\'f3n para Nacional', 50, 0),\
(17, 2, 'Nacional con RUT-Aval', 'Scoring de Nacional con RUT-Aval', 'Retroalimentaci\'f3n para Nacional con RUT-Aval', 50, 0),\
(18, 2, 'Nacional con RUT Provisional-Aval', 'Scoring de Nacional con RUT Provisional-Aval', 'Retroalimentaci\'f3n para Nacional con RUT Provisional-Aval', 30, 0),\
(19, 2, 'Pasaporte ', 'Scoring de Pasaporte-Aval', 'Retroalimentaci\'f3n para Pasaporte-Aval', 20, 0),\
(20, 3, 'Empleado', 'Scoring Empleado', 'Retroalimentaci\'f3n para Empleado', 200, 0),\
(21, 3, 'AFP Empleado', 'Scoring AFP Empleado', 'Retroalimentaci\'f3n para AFP Empleado', 20, 0),\
(22, 3, 'DICOM Empleado', 'Scoring DICOM Empleado', 'Retroalimentaci\'f3n para DICOM Empleado', 0, 1),\
(23, 3, 'Liquidaci\'f3n 1 Empleado', 'Scoring Liquidaci\'f3n 1 Empleado', 'Retroalimentaci\'f3n para Liquidaci\'f3n 1 Empleado', 5, 0),\
(24, 3, 'Liquidaci\'f3n 2 Empleado', 'Scoring Liquidaci\'f3n 2 Empleado', 'Retroalimentaci\'f3n para Liquidaci\'f3n 2 Empleado', 5, 0),\
(25, 3, 'Liquidaci\'f3n 3 Empleado', 'Scoring Liquidaci\'f3n 3 Empleado', 'Retroalimentaci\'f3n para Liquidaci\'f3n 3 Empleado', 5, 0),\
(26, 3, 'Certificado de Empleo', 'Scoring Certificado de Empleo', 'Retroalimentaci\'f3n para Certificado de Empleo', 15, 0),\
(27, 3, 'Freelancer', 'Scoring Freelancer', 'Retroalimentaci\'f3n para Freelancer', 170, 0),\
(28, 3, 'AFP Freelancer', 'Scoring Validaci\'f3n de AFP Freelancer', 'Retroalimentaci\'f3n para Validaci\'f3n AFP Freelancer', 20, 0),\
(29, 3, 'DICOM Freelancer', 'Scoring de DICOM Freelancer', 'Retroalimentaci\'f3n para DICOM Freelancer', 0, 1),\
(30, 3, 'Respaldo Otros Ingresos Freelancer', 'Scoring de Respaldo Otros Ingresos Freelancer', 'Retroalimentaci\'f3n para  Respaldo Otros Ingresos Freelancer', 10, 0),\
(31, 3, 'Cuenta Bancaria / Ahorro Freelancer', 'Scoring de Cuenta Bancaria / Ahorro Freelancer', 'Retroalimentaci\'f3n para Cuenta Bancaria / Ahorro Freelancer', 10, 0),\
(32, 3, 'Boleta de Honorarios Freelancer', 'Scoring de Boleta de Honorarios Freelancer', 'Retroalimentaci\'f3n para Boleta de Honorarios Freelancer', 10, 0),\
(33, 3, 'Desempleado', 'Scoring de Desempleado', 'Retroalimentaci\'f3n para  Desempleado', 100, 0),\
(34, 3, 'AFP Desempleado', 'Scoring de AFP Desempleado', 'Retroalimentaci\'f3n para AFP Desempleado', 20, 0),\
(35, 3, 'DICOM Desempleado', 'Scoring de DICOM Desempleado', 'Retroalimentaci\'f3n para  DICOM Desempleado', 0, 1),\
(36, 3, 'Respaldo Otros Ingresos Desempleado', 'Scoring de Respaldo Otros Ingresos Desempleado', 'Retroalimentaci\'f3n para  Respaldo Otros Ingresos Desempleado', 10, 0),\
(37, 3, 'Cuenta Bancaria / Ahorro Desempleado', 'Scoring de Cuenta Bancaria / Ahorro Desempleado', 'Retroalimentaci\'f3n para Cuenta Bancaria / Ahorro  Desempleado', 20, 0),\
(38, 4, 'Tipo de Propiedad', 'Scoring de Tipo de Propiedad', 'Retroalimentaci\'f3n para  Tipo de Propiedad', 1, 0),\
(39, 4, 'Tipo de Residente', 'Scoring de Tipo de Residente (Solteros, casados ...)', 'Retroalimentaci\'f3n para  Tipo de Residente ', 1, 0),\
(40, 4, 'Fecha de Mudanza', 'Scoring de Fecha de Mudanza', 'Retroalimentaci\'f3n para  Fecha de Mudanza', 1, 0),\
(41, 4, 'Mascota', 'Scoring de  Mascota', 'Retroalimentaci\'f3n para Mascota', 1, 0),\
(42, 4, 'Fumador', 'Scoring de Fumador', 'Retroalimentaci\'f3n para Fumador', 1, 0),\
(43, 4, ' 1 Mes de garantia', 'Scoring de 1 Mes de garantia', 'Retroalimentaci\'f3n para  1 Mes de garantia', 50, 0),\
(44, 4, '2 Meses de garantia', 'Scoring de 2 Meses de garantia', 'Retroalimentaci\'f3n para  2 Meses de garantia', 60, 0),\
(45, 4, 'Mas de 2 Meses de garantia', 'Scoring de Mas de 2 Meses de garantia', 'Retroalimentaci\'f3n para Mas de 2 Meses de garantia', 70, 0),\
(46, 4, '1 Mes de Adelanto', 'Scoring de 1 Mes de Adelanto', 'Retroalimentaci\'f3n para 1 Mes de Adelanto', 50, 0),\
(47, 4, '2 Meses de Adelanto', 'Scoring de 2 Meses de Adelanto', 'Retroalimentaci\'f3n para 2 Meses de Adelanto', 60, 0),\
(48, 4, 'Mas de 2 Meses de Adelanto', 'Scoring de Mas de 2  Meses de Adelanto', 'Retroalimentaci\'f3n para Mas de 2  Meses de Adelanto', 70, 0),\
(49, 4, 'Tiempo de Arriendo menor a 12 meses', 'Scoring de Tiempo de Arriendo menor a 12 meses', 'Retroalimentaci\'f3n para  Tiempo de Arriendo menor a 12 meses', 5, 0),\
(50, 4, 'Tiempo de Arriendo igual o mayor a 12 meses', 'Scoring de Tiempo de Arriendo igual o  mayor a 12 meses', 'Retroalimentaci\'f3n para  Tiempo de Arriendo igual o mayor a 12 meses', 20, 0),\
(51, 5, 'Membres\'eda Basic', 'Scoring de Membres\'eda Basic', 'Retroalimentaci\'f3n para  Membres\'eda Basic', 30, 0),\
(52, 5, 'Membres\'eda Select', 'Scoring de Membres\'eda Select', 'Retroalimentaci\'f3n para  Membres\'eda Select', 70, 0),\
(53, 5, 'Membres\'eda Prime', 'Scoring de Membres\'eda Prime', 'Retroalimentaci\'f3n para  Membres\'eda Prime', 90, 0),\
(54, 6, 'Variable Financiera', 'Scoring de Variable Financiera', 'Retroalimentaci\'f3n para Variable Financiera', 420, 1),\
(55, 7, 'Demanda Alta', 'Scoring de Demanda Alta', 'Retroalimentaci\'f3n para Demanda Alta', 70, 0),\
(56, 7, 'Demanda Media', 'Scoring de Demanda Media', 'Retroalimentaci\'f3n para Demanda Media', 60, 0),\
(57, 7, 'Demanda Baja', 'Scoring de Demanda Baja', 'Retroalimentaci\'f3n para Demanda Baja', 50, 0);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `files`\
--\
\
CREATE TABLE `files` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `type` tinyint(4) DEFAULT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `original_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `path` text COLLATE utf8mb4_unicode_ci,\
  `verified` tinyint(1) NOT NULL DEFAULT '0',\
  `expires_at` date DEFAULT NULL,\
  `val_date` tinyint(1) NOT NULL DEFAULT '0',\
  `factor` int(11) NOT NULL DEFAULT '0',\
  `code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `s3` text COLLATE utf8mb4_unicode_ci,\
  `id_videoindexer` text COLLATE utf8mb4_unicode_ci,\
  `thumbnail` text COLLATE utf8mb4_unicode_ci,\
  `verified_ocr` tinyint(1) NOT NULL DEFAULT '0',\
  `user_id` int(10) UNSIGNED DEFAULT NULL,\
  `property_id` int(10) UNSIGNED DEFAULT NULL,\
  `company_id` int(10) UNSIGNED DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `files`\
--\
\
INSERT INTO `files` (`id`, `type`, `name`, `original_name`, `path`, `verified`, `expires_at`, `val_date`, `factor`, `code`, `s3`, `id_videoindexer`, `thumbnail`, `verified_ocr`, `user_id`, `property_id`, `company_id`) VALUES\
(1, 4, 'last_electricity_bill', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 5, NULL),\
(2, 4, 'last_water_bill', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 5, NULL),\
(3, 4, 'common_expense_receipt', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 5, NULL),\
(4, 4, 'property_certificate', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 5, NULL),\
(5, NULL, 'id_front', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL),\
(6, NULL, 'id_back', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL),\
(7, NULL, 'afp', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL),\
(8, NULL, 'dicom', NULL, NULL, 1, NULL, 0, 1000, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL),\
(9, NULL, 'id_front', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 2, NULL, NULL),\
(10, NULL, 'id_back', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 2, NULL, NULL),\
(11, NULL, 'afp', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 2, NULL, NULL),\
(12, NULL, 'dicom', NULL, NULL, 0, NULL, 1, 1000, NULL, NULL, NULL, NULL, 0, 2, NULL, NULL),\
(13, NULL, 'id_front', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 3, NULL, NULL),\
(14, NULL, 'id_back', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 3, NULL, NULL),\
(15, NULL, 'afp', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 3, NULL, NULL),\
(16, NULL, 'dicom', NULL, NULL, 1, NULL, 1, 1000, NULL, NULL, NULL, NULL, 0, 3, NULL, NULL),\
(17, NULL, 'id_front', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 4, NULL, NULL),\
(18, NULL, 'id_back', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 4, NULL, NULL),\
(19, NULL, 'afp', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 4, NULL, NULL),\
(20, NULL, 'dicom', NULL, NULL, 1, NULL, 0, 1000, NULL, NULL, NULL, NULL, 0, 4, NULL, NULL),\
(21, NULL, 'id_front', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 5, NULL, NULL),\
(22, NULL, 'id_back', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 5, NULL, NULL),\
(23, NULL, 'afp', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 5, NULL, NULL),\
(24, NULL, 'dicom', NULL, NULL, 0, NULL, 0, 1000, NULL, NULL, NULL, NULL, 0, 5, NULL, NULL),\
(25, NULL, 'id_front', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 6, NULL, NULL),\
(26, NULL, 'id_back', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 6, NULL, NULL),\
(27, NULL, 'afp', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 6, NULL, NULL),\
(28, NULL, 'dicom', NULL, NULL, 1, NULL, 1, 1000, NULL, NULL, NULL, NULL, 0, 6, NULL, NULL),\
(29, NULL, 'id_front', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 7, NULL, NULL),\
(30, NULL, 'id_back', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 7, NULL, NULL),\
(31, NULL, 'afp', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 7, NULL, NULL),\
(32, NULL, 'dicom', NULL, NULL, 0, NULL, 0, 1000, NULL, NULL, NULL, NULL, 0, 7, NULL, NULL),\
(33, NULL, 'id_front', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 8, NULL, NULL),\
(34, NULL, 'id_back', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 8, NULL, NULL),\
(35, NULL, 'afp', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 8, NULL, NULL),\
(36, NULL, 'dicom', NULL, NULL, 1, NULL, 0, 1000, NULL, NULL, NULL, NULL, 0, 8, NULL, NULL),\
(37, NULL, 'id_front', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 9, NULL, NULL),\
(38, NULL, 'id_back', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 9, NULL, NULL),\
(39, NULL, 'afp', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 9, NULL, NULL),\
(40, NULL, 'dicom', NULL, NULL, 0, NULL, 0, 1000, NULL, NULL, NULL, NULL, 0, 9, NULL, NULL),\
(41, NULL, 'id_front', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 10, NULL, NULL),\
(42, NULL, 'id_back', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 10, NULL, NULL),\
(43, NULL, 'afp', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 10, NULL, NULL),\
(44, NULL, 'dicom', NULL, NULL, 0, NULL, 1, 1000, NULL, NULL, NULL, NULL, 0, 10, NULL, NULL),\
(45, NULL, 'id_front', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 11, NULL, NULL),\
(46, NULL, 'id_back', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 11, NULL, NULL),\
(47, NULL, 'afp', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 11, NULL, NULL),\
(48, NULL, 'dicom', NULL, NULL, 0, NULL, 0, 1000, NULL, NULL, NULL, NULL, 0, 11, NULL, NULL),\
(49, NULL, 'id_front', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 13, NULL, NULL),\
(50, NULL, 'id_back', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 13, NULL, NULL),\
(51, NULL, 'afp', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 13, NULL, NULL),\
(52, NULL, 'dicom', NULL, NULL, 0, NULL, 1, 1000, NULL, NULL, NULL, NULL, 0, 13, NULL, NULL),\
(53, NULL, 'id_front', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 14, NULL, NULL),\
(54, NULL, 'id_back', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 14, NULL, NULL),\
(55, NULL, 'afp', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 14, NULL, NULL),\
(56, NULL, 'dicom', NULL, NULL, 0, NULL, 1, 1000, NULL, NULL, NULL, NULL, 0, 14, NULL, NULL),\
(57, NULL, 'first_settlement', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL),\
(58, NULL, 'second_settlement', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL),\
(59, NULL, 'third_settlement', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL),\
(60, NULL, 'work_constancy', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 1, NULL, NULL),\
(61, NULL, 'first_settlement', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 14, NULL, NULL),\
(62, NULL, 'second_settlement', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 14, NULL, NULL),\
(63, NULL, 'third_settlement', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 14, NULL, NULL),\
(64, NULL, 'work_constancy', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 14, NULL, NULL),\
(65, NULL, 'other_income', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 2, NULL, NULL),\
(66, NULL, 'last_invoice', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 2, NULL, NULL),\
(67, NULL, 'saves', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 2, NULL, NULL),\
(68, NULL, 'other_income', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 3, NULL, NULL),\
(69, NULL, 'saves', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 3, NULL, NULL),\
(70, NULL, 'other_income', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 4, NULL, NULL),\
(71, NULL, 'saves', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 4, NULL, NULL),\
(72, NULL, 'other_income', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 5, NULL, NULL),\
(73, NULL, 'saves', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 5, NULL, NULL),\
(74, NULL, 'other_income', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 6, NULL, NULL),\
(75, NULL, 'saves', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 6, NULL, NULL),\
(76, NULL, 'other_income', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 7, NULL, NULL),\
(77, NULL, 'saves', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 7, NULL, NULL),\
(78, NULL, 'other_income', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 8, NULL, NULL),\
(79, NULL, 'saves', NULL, NULL, 1, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 8, NULL, NULL),\
(80, NULL, 'other_income', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 9, NULL, NULL),\
(81, NULL, 'saves', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 9, NULL, NULL),\
(82, NULL, 'other_income', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 10, NULL, NULL),\
(83, NULL, 'saves', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 10, NULL, NULL),\
(84, NULL, 'other_income', NULL, NULL, 0, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 11, NULL, NULL),\
(85, NULL, 'saves', NULL, NULL, 1, NULL, 1, 0, NULL, NULL, NULL, NULL, 0, 11, NULL, NULL),\
(86, NULL, 'other_income', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 12, NULL, NULL),\
(87, NULL, 'saves', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 12, NULL, NULL),\
(88, 1, 'id_front', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 15, NULL, NULL),\
(89, 1, 'id_back', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 15, NULL, NULL),\
(90, 1, 'id_front', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 16, NULL, NULL),\
(91, 1, 'id_back', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 16, NULL, NULL),\
(92, 4, 'last_electricity_bill', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 6, NULL),\
(93, 4, 'last_water_bill', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 6, NULL),\
(94, 4, 'common_expense_receipt', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 6, NULL),\
(95, 4, 'property_certificate', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 6, NULL),\
(96, 3, 'dicom', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 16, NULL, NULL),\
(97, 1, 'id_front', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 17, NULL, NULL),\
(98, 1, 'id_back', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 17, NULL, NULL),\
(99, 4, 'last_electricity_bill', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 7, NULL),\
(100, 4, 'last_water_bill', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 7, NULL),\
(101, 4, 'common_expense_receipt', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 7, NULL),\
(102, 4, 'property_certificate', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, 7, NULL),\
(113, 1, 'id_front', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 23, NULL, NULL),\
(114, 1, 'id_back', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 23, NULL, NULL),\
(115, 3, 'dicom', NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, NULL, 0, 23, NULL, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `memberships`\
--\
\
CREATE TABLE `memberships` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `features` json NOT NULL,\
  `enabled` tinyint(1) NOT NULL DEFAULT '1',\
  `role_id` int(10) UNSIGNED NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `memberships`\
--\
\
INSERT INTO `memberships` (`id`, `name`, `features`, `enabled`, `role_id`) VALUES\
(1, 'Basic', '\{\\"commission\\": 0, \\"trust_seal\\": 0, \\"smart_agent\\": 1, \\"owner_contact\\": 0, \\"score_display\\": 1, \\"package_amount\\": \\"0\\", \\"recommendations\\": 0, \\"owner_verification\\": 1, \\"suggestions_to_owners\\": 0, \\"display_all_properties\\": 1, \\"applications_received_count\\": 2\}', 1, 1),\
(2, 'Select', '\{\\"commission\\": 0, \\"trust_seal\\": 0, \\"smart_agent\\": 1, \\"owner_contact\\": 1, \\"score_display\\": 1, \\"package_amount\\": \\"9.500\\", \\"recommendations\\": 1, \\"owner_verification\\": 1, \\"suggestions_to_owners\\": 1, \\"display_all_properties\\": 1, \\"applications_received_count\\": 8\}', 1, 1),\
(3, 'Premium', '\{\\"commission\\": 0, \\"trust_seal\\": 1, \\"smart_agent\\": 1, \\"owner_contact\\": 2, \\"score_display\\": 1, \\"package_amount\\": \\"14.750\\", \\"recommendations\\": 2, \\"owner_verification\\": 1, \\"suggestions_to_owners\\": 1, \\"display_all_properties\\": 1, \\"applications_received_count\\": -1\}', 1, 1),\
(4, 'Default', '\{\\"hey\\": \\"ho\\"\}', 0, 1),\
(5, 'Basic', '\{\\"trust_seal\\": false, \\"smart_agent\\": false, \\"owner_contact\\": 0, \\"score_display\\": true, \\"tenanting_fee\\": \\"15\\", \\"package_amount\\": \\"0\\", \\"public_support\\": false, \\"recommendations\\": 0, \\"properties_count\\": -1, \\"application_count\\": -1, \\"owner_verification\\": true, \\"suggestions_to_tenants\\": false, \\"applications_received_count\\": 2\}', 1, 2),\
(6, 'Select', '\{\\"trust_seal\\": false, \\"smart_agent\\": true, \\"owner_contact\\": 1, \\"score_display\\": true, \\"tenanting_fee\\": \\"15\\", \\"package_amount\\": \\"16.750\\", \\"public_support\\": true, \\"recommendations\\": 1, \\"properties_count\\": -1, \\"application_count\\": -1, \\"owner_verification\\": true, \\"suggestions_to_tenants\\": true, \\"applications_received_count\\": 8\}', 1, 2),\
(7, 'Premium', '\{\\"trust_seal\\": true, \\"smart_agent\\": true, \\"owner_contact\\": 2, \\"score_display\\": true, \\"tenanting_fee\\": \\"15\\", \\"package_amount\\": \\"22.550\\", \\"public_support\\": true, \\"recommendations\\": 2, \\"properties_count\\": -1, \\"application_count\\": -1, \\"owner_verification\\": true, \\"suggestions_to_tenants\\": true, \\"applications_received_count\\": -1\}', 1, 2),\
(8, 'Default', '\{\\"hey\\": \\"ho\\"\}', 0, 2),\
(9, 'Basic', '\{\\"owner_contact\\": 0, \\"package_amount\\": \\"7.550\\", \\"public_support\\": false, \\"recommendations\\": 0, \\"project_due_days\\": 15, \\"photos_per_project\\": 5, \\"videos_per_project\\": 0, \\"montly_publications\\": 1\}', 1, 3),\
(10, 'Select', '\{\\"owner_contact\\": 1, \\"package_amount\\": \\"16.550\\", \\"public_support\\": true, \\"recommendations\\": 1, \\"project_due_days\\": 30, \\"photos_per_project\\": 8, \\"videos_per_project\\": 0, \\"montly_publications\\": 5\}', 1, 3),\
(11, 'Premium', '\{\\"owner_contact\\": 2, \\"package_amount\\": \\"20.550\\", \\"public_support\\": true, \\"recommendations\\": 2, \\"project_due_days\\": 30, \\"photos_per_project\\": 15, \\"videos_per_project\\": 1, \\"montly_publications\\": -1\}', 1, 3),\
(12, 'Default', '\{\\"hey\\": \\"ho\\"\}', 0, 3),\
(13, 'Basic', '\{\\"add_days\\": 5, \\"add_zones\\": 0, \\"trust_seal\\": false, \\"service_fee\\": 0, \\"main_services\\": 1, \\"owner_contact\\": 0, \\"package_amount\\": \\"990\\", \\"public_support\\": 0, \\"recommendations\\": 0, \\"services_counts\\": -1, \\"project_due_days\\": 5, \\"photos_per_project\\": 3, \\"secondary_services\\": 1, \\"videos_per_project\\": 0\}', 1, 4),\
(14, 'Select', '\{\\"add_days\\": 15, \\"add_zones\\": 0, \\"trust_seal\\": false, \\"service_fee\\": 0, \\"main_services\\": 2, \\"owner_contact\\": 1, \\"package_amount\\": \\"3.250\\", \\"public_support\\": 0, \\"recommendations\\": 1, \\"services_counts\\": -1, \\"project_due_days\\": 15, \\"photos_per_project\\": 5, \\"secondary_services\\": 4, \\"videos_per_project\\": 0\}', 1, 4),\
(15, 'Premium', '\{\\"add_days\\": 30, \\"add_zones\\": 2, \\"trust_seal\\": true, \\"service_fee\\": 0, \\"main_services\\": 3, \\"owner_contact\\": 2, \\"package_amount\\": \\"6.550\\", \\"public_support\\": 1, \\"recommendations\\": 2, \\"services_counts\\": -1, \\"project_due_days\\": 30, \\"photos_per_project\\": 10, \\"secondary_services\\": 9, \\"videos_per_project\\": 1\}', 1, 4),\
(16, 'Default', '\{\\"hey\\": \\"ho\\"\}', 0, 4),\
(17, 'Default', '\{\\"hey\\": \\"ho\\"\}', 0, 5);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `messages`\
--\
\
CREATE TABLE `messages` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `from_id` int(10) UNSIGNED NOT NULL,\
  `to_id` int(10) UNSIGNED NOT NULL,\
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `messages`\
--\
\
INSERT INTO `messages` (`id`, `from_id`, `to_id`, `content`, `created_at`, `updated_at`) VALUES\
(1, 1, 2, 'Hola, c\'f3mo est\'e1s? Me gusta la propiedad publicada.', '2020-01-21 00:12:33', '2020-01-21 00:12:33'),\
(2, 2, 1, 'Bien, gracias. Y tu? Ok, hablemos de ello.', '2020-01-21 00:12:34', '2020-01-21 00:12:34'),\
(3, 1, 3, 'Saludos, feliz s\'e1bado. Pudiste subir las nuevas fotos que te ped\'ed?', '2020-01-21 00:12:34', '2020-01-21 00:12:34'),\
(4, 3, 1, 'igual para t\'ed. Que tal? Si, revisa la publicaci\'f3n, ya actualic\'e9 las fotos con la vista pedida, para que puedas verlas.', '2020-01-21 00:12:34', '2020-01-21 00:12:34');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `migrations`\
--\
\
CREATE TABLE `migrations` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `batch` int(11) NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `migrations`\
--\
\
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES\
(1, '2018_10_05_133142_database', 1),\
(2, '2018_12_03_003927_create_store_functions', 1),\
(3, '2019_02_09_121753_adds_api_token_to_users_table', 1),\
(4, '2019_03_22_091516_create_useradmin_table', 1),\
(5, '2019_05_14_112543_create_sasapplicants_table', 1),\
(6, '2019_05_30_112156_add_role_to_usersadmin', 1),\
(7, '2019_07_04_140309_update_role_useradmin', 1),\
(8, '2019_08_07_125501_update_store_functions', 1),\
(9, '2019_08_07_171140_update_table_properties', 1),\
(10, '2019_08_08_165908_update_view_v_services', 1),\
(11, '2019_08_09_144342_update_v_properties', 1),\
(12, '2019_08_13_184948_update_v_agents', 1),\
(13, '2019_08_14_120017_update_sf_job_user_score', 1),\
(14, '2019_08_20_180527_update_sf_docs_user_score', 1),\
(15, '2019_08_21_164533_alter_table_properties', 1),\
(16, '2019_08_22_183149_update_v_agents2', 1),\
(17, '2019_08_27_105541_update_sf_demand_property', 1),\
(18, '2019_08_28_105225_update_table_properties2', 1),\
(19, '2019_08_29_121244_agregar_campo_anexos_condiciones', 1),\
(20, '2019_09_02_103311_tipificar_arrendatarios_por_estadia', 1),\
(21, '2019_09_03_143632_update_v_services2', 1),\
(22, '2019_09_03_145947_tipificar_propiedades_estadia', 1),\
(23, '2019_09_05_111139_campos_properties_for_short_stay', 1),\
(24, '2019_09_06_173632_add_new_fields_property_short_stay', 1),\
(25, '2019_09_10_161158_update_scoring', 1),\
(26, '2019_09_16_152928_update_v_properties_16_09_2019', 1),\
(27, '2019_09_17_132827_create_visits_table', 1),\
(28, '2019_09_23_162640_create_postulated_days', 1),\
(29, '2019_09_24_090407_update_data_properties', 1),\
(30, '2019_09_25_112316_update_table_properties3', 1),\
(31, '2019_09_26_122345_update_table_properties_for', 1),\
(32, '2019_09_30_171624_add_cleaning_rate_column_in_properties', 1),\
(33, '2019_10_08_162901_update_sf_demand_property2', 1),\
(34, '2019_10_09_145658_update_v_properties_09_10_2019', 1),\
(35, '2019_10_10_154821_v_properties_10_10_2019', 1),\
(36, '2019_10_14_144344_update_memberships_14_10_2019', 1),\
(37, '2019_10_24_155059_alter_table_properties_24_10_2019', 1),\
(38, '2019_10_28_122351_update_table_usersadmins_28_10_2019', 1),\
(39, '2019_11_06_134216_update_table_properties_06_11_2019', 1),\
(40, '2019_11_07_084937_update_table_amenities_07_11_2019', 1),\
(41, '2019_11_15_112302_alter_table_properties_15_11_2019', 1),\
(42, '2019_11_22_083725_create_table_coupons22_11_2019', 1),\
(43, '2019_11_27_115212_create_table_configurations_27_11_2019', 1),\
(44, '2019_11_29_013926_update_v_properties_29_11_2019', 1),\
(45, '2019_12_12_091938_alter_table_payments_12_12_2019', 1),\
(46, '2019_12_20_160109_alter_v_properties_20_12_2019', 1),\
(47, '2020_01_08_102220_v_alter_views_properties_08_01_2020', 1);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `newsletters`\
--\
\
CREATE TABLE `newsletters` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `firstname` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `lastname` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `cell_phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `email` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `bathrooms` int(11) DEFAULT NULL,\
  `bedrooms` int(11) DEFAULT NULL,\
  `price` int(11) DEFAULT NULL,\
  `furnished_date` date DEFAULT NULL,\
  `commune_id` int(10) UNSIGNED DEFAULT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `notifications`\
--\
\
CREATE TABLE `notifications` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL,\
  `deleted_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `notifications`\
--\
\
INSERT INTO `notifications` (`id`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES\
(1, 'Notificaciones de Nuevas Propiedades', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(2, 'Notificaciones de Servicios que podr\'edan interesarte', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(3, 'Notificaciones de Proyectos', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(4, 'Noticias de anuncios de uHomie', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(5, 'Un Arrendador acept\'f3 tu postulaci\'f3n', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(6, 'Uhomie te pide tramitar la firma del contrato digital', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(7, 'Uhomie te pide renovar tu membresia', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(8, 'Notificaci\'f3n de vencimiento de membres\'eda.', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(9, 'Compartir solo tus datos asociados a tu ficha de postulaci\'f3n al arrendador', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(10, 'Nuevos Clientes que han dado click a tu propiedad', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(11, 'Un arrendatario acept\'f3 tu contrato de arriendo', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(12, 'Compartir solo tus datos asociados a tu ficha de propiedad con arrendatarios', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `password_resets`\
--\
\
CREATE TABLE `password_resets` (\
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `created_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `payments`\
--\
\
CREATE TABLE `payments` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `order` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `user_id` int(10) UNSIGNED NOT NULL,\
  `status` int(11) NOT NULL DEFAULT '0',\
  `amount` double(11,2) NOT NULL,\
  `iva` double(11,2) NOT NULL,\
  `total` double(11,2) NOT NULL,\
  `method` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `currency` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `exchange_rate` double(8,2) DEFAULT NULL,\
  `token_ws` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `details` text COLLATE utf8mb4_unicode_ci,\
  `tenanting_insurance` tinyint(1) DEFAULT NULL,\
  `service_amount` double(11,2) DEFAULT NULL,\
  `contract_id` int(10) UNSIGNED DEFAULT NULL,\
  `property_id` int(10) UNSIGNED DEFAULT NULL,\
  `token` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `coupon` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `payments`\
--\
\
INSERT INTO `payments` (`id`, `order`, `user_id`, `status`, `amount`, `iva`, `total`, `method`, `currency`, `exchange_rate`, `token_ws`, `details`, `tenanting_insurance`, `service_amount`, `contract_id`, `property_id`, `token`, `coupon`, `created_at`, `updated_at`) VALUES\
(1, 'order', 1, 1, 1200.00, 12.00, 2000.00, 'debito', 'currency', 122.00, NULL, 'payment 1 details', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),\
(2, 'o_200201_16_0', 16, 0, 16750.00, 19.00, 19932.00, 'transbank', 'CLP', 1.00, NULL, 'Pago de Membresia uHomie tipo: Select para Propietario', NULL, NULL, NULL, NULL, 'gA0cP5NeYeUUSXOPTyiQ5QdKvrhUtDaLc3o2pa7Y', NULL, '2020-02-02 02:48:43', '2020-02-02 02:48:43');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `photos`\
--\
\
CREATE TABLE `photos` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `original_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `cover` tinyint(1) NOT NULL DEFAULT '0',\
  `logo` tinyint(1) NOT NULL DEFAULT '0',\
  `path` text COLLATE utf8mb4_unicode_ci,\
  `user_id` int(10) UNSIGNED DEFAULT NULL,\
  `property_id` int(10) UNSIGNED DEFAULT NULL,\
  `company_id` int(10) UNSIGNED DEFAULT NULL,\
  `service_list_id` int(10) UNSIGNED DEFAULT NULL,\
  `space_id` int(10) UNSIGNED DEFAULT NULL,\
  `block` tinyint(4) DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `photos`\
--\
\
INSERT INTO `photos` (`id`, `name`, `original_name`, `cover`, `logo`, `path`, `user_id`, `property_id`, `company_id`, `service_list_id`, `space_id`, `block`) VALUES\
(1, 'frente1', 'frente_completo1', 1, 0, '/images/explore/img_propiedad.png', 7, 1, NULL, NULL, NULL, NULL),\
(2, 'frente2', 'frente_completo2', 1, 0, '/images/explore/img_propiedad.png', 8, 2, NULL, NULL, NULL, NULL),\
(3, 'frente3', 'frente_completo3', 1, 0, '/images/explore/img_propiedad.png', 9, 3, NULL, NULL, NULL, NULL),\
(4, 'frente4', 'frente_completo4', 1, 0, '/images/explore/img_propiedad.png', 1, 4, NULL, NULL, NULL, NULL),\
(5, 'frente5', 'frente_completo4', 1, 0, '/images/explore/img_propiedad.png', 13, 5, NULL, NULL, NULL, NULL),\
(6, 'photo_-20200201060236306720.jpeg', '15805966554821_zVDcaM6mqhi9m0LP_Sq4Ag.jpeg', 1, 0, '/storage/properties/6/photos/photo_-20200201060236306720.jpeg', NULL, 6, NULL, NULL, 6, NULL),\
(7, 'photo_-20200201060210266166.jpg', '1580596689970code-1076533_960_720.jpg', 0, 0, '/storage/properties/6/photos/photo_-20200201060210266166.jpg', NULL, 6, NULL, NULL, 8, NULL),\
(8, 'photo_-20200201060214616858.jpeg', '1580596694377full-stack-web-developer.jpg_0.jpeg', 0, 0, '/storage/properties/6/photos/photo_-20200201060214616858.jpeg', NULL, 6, NULL, NULL, 5, NULL),\
(9, 'photo_-20200201060218046302.jpeg', '1580596697855full-stack-javascript-developer-e-degree-bundle.jpeg', 0, 0, '/storage/properties/6/photos/photo_-20200201060218046302.jpeg', NULL, 6, NULL, NULL, 7, NULL),\
(10, 'photo_-20200201070229260402.jpeg', '15806003689271_GF_dOBH7hPCfULtmlOl24Q.jpeg', 1, 0, '/storage/properties/7/photos/photo_-20200201070229260402.jpeg', NULL, 7, NULL, NULL, 6, NULL),\
(11, 'photo_-20200201070245456360.jpg', '1580600385189code-1076533_960_720.jpg', 0, 0, '/storage/properties/7/photos/photo_-20200201070245456360.jpg', NULL, 7, NULL, NULL, 7, NULL),\
(12, 'photo_-20200201070252301355.jpg', '1580600392089luca-bravo-217276-unsplash.jpg', 0, 0, '/storage/properties/7/photos/photo_-20200201070252301355.jpg', NULL, 7, NULL, NULL, 8, NULL),\
(13, 'photo_-20200201070259950497.jpg', '1580600399661PAK_MT9V9A6981_TP_V.jpg', 0, 0, '/storage/properties/7/photos/photo_-20200201070259950497.jpg', NULL, 7, NULL, NULL, 5, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `postulates`\
--\
\
CREATE TABLE `postulates` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `state` tinyint(4) NOT NULL DEFAULT '0',\
  `espera` tinyint(1) NOT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `privacies`\
--\
\
CREATE TABLE `privacies` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL,\
  `deleted_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `privacies`\
--\
\
INSERT INTO `privacies` (`id`, `name`, `created_at`, `updated_at`, `deleted_at`) VALUES\
(1, 'Uhomie solo podr\'e1 compartir tus datos asociados a tu  ficha de postulaci\'f3n a los due\'f1os.', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(2, 'Uhomie no podr\'e1 compartir tus datos asociados a tu  ficha de postulaci\'f3n a arrendadores que no hayas postulado.', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(3, 'Uhomie mantendr\'e1 hasta por 12 meses tus datos de  postulaci\'f3n a las propiedades en las que fuiste aceptado y tramitaste tu contrato de forma exitosa.             Solo podr\'e1 ser consultado por tu arrendador vigente.', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(4, 'Uhomie eliminar\'e1 toda postulaci\'f3n a aquellas propiedades donde no fuiste aceptado, arrendadores no podr\'e1n ver tus datos.', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(5, 'Uhomie solo podr\'e1 compartir tus datos asociados a tu ficha de propiedad con arrendatarios que est\'e9n  interesados en tu propiedad.', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(6, 'Uhomie no podr\'e1 compartir tus datos asociados a tu ficha de propiedad a arrendatarios que no hayan postulado.', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL),\
(7, 'Sobre tu propiedad, una vez que hayas aceptado a otros arrendatarios, no podr\'e1s ver datos de los postulantes que hayan quedado fuera del proceso.1', '2020-01-21 00:12:32', '2020-01-21 00:12:32', NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `properties`\
--\
\
CREATE TABLE `properties` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `active` tinyint(1) NOT NULL DEFAULT '0',\
  `status` tinyint(4) NOT NULL DEFAULT '1',\
  `views` int(11) NOT NULL DEFAULT '0',\
  `available` tinyint(1) NOT NULL DEFAULT '1',\
  `address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `address_details` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `rent` int(11) NOT NULL DEFAULT '0',\
  `rent_up` int(11) NOT NULL DEFAULT '0',\
  `description` text COLLATE utf8mb4_unicode_ci,\
  `builder` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `architect` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `is_project` tinyint(1) NOT NULL DEFAULT '0',\
  `tenanting_insurance` tinyint(1) NOT NULL DEFAULT '0',\
  `common_expenses` tinyint(1) DEFAULT NULL,\
  `common_expenses_support` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `property_certificate` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `condition` tinyint(1) DEFAULT NULL,\
  `meters` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `latitude` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `longitude` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `expenses_limit` int(11) DEFAULT NULL,\
  `common_expenses_limit` int(11) DEFAULT NULL,\
  `warranty_months_quantity` int(11) DEFAULT NULL,\
  `months_advance_quantity` int(11) DEFAULT NULL,\
  `available_date` date DEFAULT NULL,\
  `tenanting_months_quantity` int(11) DEFAULT NULL,\
  `collateral_require` tinyint(1) DEFAULT NULL,\
  `furnished` tinyint(1) DEFAULT NULL,\
  `single_beds` int(11) DEFAULT NULL,\
  `double_beds` int(11) DEFAULT NULL,\
  `number_furnished` int(11) DEFAULT NULL,\
  `furnished_description` text COLLATE utf8mb4_unicode_ci,\
  `cellar` tinyint(1) DEFAULT NULL,\
  `cellar_description` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `schedule_range` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `visit` tinyint(1) DEFAULT NULL,\
  `visit_from_date` date DEFAULT NULL,\
  `visit_to_date` date DEFAULT NULL,\
  `anexo_conditions` text COLLATE utf8mb4_unicode_ci,\
  `schedule_dates` json DEFAULT NULL,\
  `bedrooms` int(11) DEFAULT NULL,\
  `bathrooms` int(11) DEFAULT NULL,\
  `pool` tinyint(1) DEFAULT NULL,\
  `garden` tinyint(1) DEFAULT NULL,\
  `terrace` tinyint(1) DEFAULT NULL,\
  `private_parking` int(11) DEFAULT NULL,\
  `public_parking` tinyint(1) DEFAULT NULL,\
  `pet_preference` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `smoking_allowed` tinyint(1) NOT NULL DEFAULT '0',\
  `nationals_with_rut` tinyint(1) DEFAULT NULL,\
  `foreigners_with_rut` tinyint(1) DEFAULT NULL,\
  `foreigners_with_passport` tinyint(1) DEFAULT NULL,\
  `redirect` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `verified` tinyint(1) DEFAULT NULL,\
  `manage` tinyint(4) NOT NULL DEFAULT '0',\
  `warranty_ticket_price` int(11) DEFAULT NULL,\
  `warranty_ticket` tinyint(1) DEFAULT NULL,\
  `penalty_fees` int(11) DEFAULT NULL,\
  `rent_year_3` int(11) NOT NULL DEFAULT '0',\
  `rent_year_2` int(11) NOT NULL DEFAULT '0',\
  `rent_year_1` int(11) NOT NULL DEFAULT '0',\
  `term_year` int(11) DEFAULT NULL,\
  `exclusions` text COLLATE utf8mb4_unicode_ci,\
  `meeting_room` int(11) DEFAULT NULL,\
  `rooms` int(11) DEFAULT NULL,\
  `level` int(11) DEFAULT NULL,\
  `building_name` text COLLATE utf8mb4_unicode_ci,\
  `work_electric_water` tinyint(1) DEFAULT NULL,\
  `arquitecture_project` tinyint(1) DEFAULT NULL,\
  `civil_work` tinyint(1) DEFAULT NULL,\
  `room_enablement` tinyint(1) DEFAULT NULL,\
  `commune_id` int(10) UNSIGNED DEFAULT NULL,\
  `property_type_id` int(10) UNSIGNED NOT NULL,\
  `city_id` int(10) UNSIGNED DEFAULT NULL,\
  `company_id` int(10) UNSIGNED DEFAULT NULL,\
  `executive_id` int(10) UNSIGNED DEFAULT NULL,\
  `expire_at` date DEFAULT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL,\
  `deleted_at` timestamp NULL DEFAULT NULL,\
  `type_stay` enum('SHORT_STAY','LONG_STAY') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'LONG_STAY',\
  `special_sale` tinyint(1) NOT NULL DEFAULT '0',\
  `week_sale` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',\
  `month_sale` tinyint(3) UNSIGNED NOT NULL DEFAULT '0',\
  `minimum_nights` tinyint(3) UNSIGNED NOT NULL DEFAULT '1',\
  `checkin_hour` tinyint(3) UNSIGNED NOT NULL DEFAULT '9',\
  `checkout_hour` tinyint(3) UNSIGNED NOT NULL DEFAULT '9',\
  `allow_small_child` tinyint(1) NOT NULL DEFAULT '0',\
  `allow_baby` tinyint(1) NOT NULL DEFAULT '0',\
  `allow_parties` tinyint(1) NOT NULL DEFAULT '0',\
  `use_stairs` tinyint(1) NOT NULL DEFAULT '0',\
  `there_could_be_noise` tinyint(1) NOT NULL DEFAULT '0',\
  `common_zones` tinyint(1) NOT NULL DEFAULT '0',\
  `services_limited` tinyint(1) NOT NULL DEFAULT '0',\
  `survellaince_camera` tinyint(1) NOT NULL DEFAULT '0',\
  `weaponry` tinyint(1) NOT NULL DEFAULT '0',\
  `dangerous_animals` tinyint(1) NOT NULL DEFAULT '0',\
  `pets_friendly` tinyint(1) NOT NULL DEFAULT '0',\
  `cleaning_rate` int(10) UNSIGNED NOT NULL DEFAULT '0',\
  `lot_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `properties`\
--\
\
INSERT INTO `properties` (`id`, `name`, `active`, `status`, `views`, `available`, `address`, `address_details`, `rent`, `rent_up`, `description`, `builder`, `architect`, `is_project`, `tenanting_insurance`, `common_expenses`, `common_expenses_support`, `property_certificate`, `condition`, `meters`, `latitude`, `longitude`, `expenses_limit`, `common_expenses_limit`, `warranty_months_quantity`, `months_advance_quantity`, `available_date`, `tenanting_months_quantity`, `collateral_require`, `furnished`, `single_beds`, `double_beds`, `number_furnished`, `furnished_description`, `cellar`, `cellar_description`, `schedule_range`, `visit`, `visit_from_date`, `visit_to_date`, `anexo_conditions`, `schedule_dates`, `bedrooms`, `bathrooms`, `pool`, `garden`, `terrace`, `private_parking`, `public_parking`, `pet_preference`, `smoking_allowed`, `nationals_with_rut`, `foreigners_with_rut`, `foreigners_with_passport`, `redirect`, `verified`, `manage`, `warranty_ticket_price`, `warranty_ticket`, `penalty_fees`, `rent_year_3`, `rent_year_2`, `rent_year_1`, `term_year`, `exclusions`, `meeting_room`, `rooms`, `level`, `building_name`, `work_electric_water`, `arquitecture_project`, `civil_work`, `room_enablement`, `commune_id`, `property_type_id`, `city_id`, `company_id`, `executive_id`, `expire_at`, `created_at`, `updated_at`, `deleted_at`, `type_stay`, `special_sale`, `week_sale`, `month_sale`, `minimum_nights`, `checkin_hour`, `checkout_hour`, `allow_small_child`, `allow_baby`, `allow_parties`, `use_stairs`, `there_could_be_noise`, `common_zones`, `services_limited`, `survellaince_camera`, `weaponry`, `dangerous_animals`, `pets_friendly`, `cleaning_rate`, `lot_number`) VALUES\
(1, 'Propiedad 1', 1, 1, 5, 1, NULL, NULL, 603977, 0, 'Voluptate quia saepe quia ducimus. Saepe amet qui autem ipsa. Omnis non maxime enim sunt impedit id. Deleniti beatae amet aut excepturi asperiores molestiae deserunt. Ab iure error est rerum itaque.', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, '782', NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-08', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, 2, NULL, NULL, NULL, 4, 2, 'cat', 1, NULL, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '2020-02-03 19:40:57', NULL, 'LONG_STAY', 0, 0, 0, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),\
(2, 'Propiedad 2', 1, 1, 0, 1, NULL, NULL, 910399, 0, 'Adipisci in eius eos in optio. Voluptatem et dolor sequi est qui et esse. Molestias ea assumenda et dolorem optio ea id. Veniam quidem officia aut nemo accusamus.', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '996', NULL, NULL, NULL, NULL, NULL, NULL, '2020-04-26', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, 2, NULL, NULL, NULL, 5, 3, 'other', 1, NULL, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 3, 1, NULL, NULL, NULL, NULL, NULL, NULL, 'LONG_STAY', 0, 0, 0, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),\
(3, 'Propiedad 3', 1, 1, 102, 1, NULL, NULL, 772481, 0, 'Magnam rerum laboriosam voluptatem consectetur. Ex qui ut voluptatem facere. Rerum neque laboriosam qui. Odit non numquam omnis omnis. Velit expedita provident qui nihil.', NULL, NULL, 0, 0, NULL, NULL, NULL, NULL, '760', NULL, NULL, NULL, NULL, NULL, NULL, '2020-03-04', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 5, 3, NULL, NULL, NULL, 5, 2, 'cat', 0, NULL, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 1, 1, NULL, NULL, NULL, NULL, '2020-02-11 19:58:25', NULL, 'LONG_STAY', 0, 0, 0, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),\
(4, 'Propiedad 4', 1, 1, 0, 1, NULL, NULL, 923463, 0, 'Dolorum nostrum delectus ratione dolorum. Et qui neque ratione impedit. Incidunt quibusdam eos non omnis optio aut voluptas nostrum.', NULL, NULL, 1, 0, NULL, NULL, NULL, NULL, '684', NULL, NULL, NULL, NULL, NULL, NULL, '2020-02-20', NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8, 2, NULL, NULL, NULL, 2, 4, 'no', 1, NULL, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 4, 1, 1, NULL, NULL, NULL, NULL, NULL, 'LONG_STAY', 0, 0, 0, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),\
(5, 'Departamento en pleno centro de Santiago', 1, 0, 0, 1, 'C\'f3ndor 1107, Santiago, Chile', 'depto 2502', 320000, 0, 'cercano a linea 1, 2 y 3', NULL, NULL, 0, 0, NULL, NULL, NULL, 0, '70', '-33.450449', '-70.6507159', NULL, NULL, 1, 1, '2019-06-30', 1, 0, 0, NULL, NULL, NULL, NULL, 0, NULL, NULL, 0, NULL, NULL, NULL, NULL, 2, 1, 0, 0, 1, 0, 1, 'no', 0, NULL, NULL, NULL, NULL, 1, 0, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 2, 127, 1, NULL, NULL, NULL, NULL, NULL, 'LONG_STAY', 0, 0, 0, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),\
(6, 'Test House', 1, 0, 3, 1, 'Bellavista, Providencia, Chile', 'asdasdasdasd', 3330333, 0, 'asdasdasdasdasd', NULL, NULL, 0, 1, NULL, NULL, NULL, 0, '127', '-33.4305679', '-70.62792569999999', NULL, 0, 2, 2, '2020-02-04', 24, 1, NULL, NULL, NULL, 10, NULL, 1, NULL, NULL, 0, NULL, NULL, NULL, NULL, 4, 2, 1, 1, 1, 1, 1, 'dog', 0, NULL, NULL, NULL, '/users/agent/r/third-step/two/', NULL, 1, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 3, NULL, NULL, NULL, '2020-02-02 02:34:59', '2020-02-02 03:08:08', NULL, 'LONG_STAY', 0, 0, 0, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL),\
(7, 'Test House', 1, 0, 152, 1, 'Libertador General Bernardo O\\'Higgins, Maip\'fa, Maipu, Chile', '234', 2000, 0, 'sdfsdfsdfsdfsdfsdf', NULL, NULL, 0, 1, NULL, NULL, NULL, 0, '10000', '-33.5026615', '-70.7714299', NULL, 0, 1, 2, '2020-02-02', 6, 1, NULL, NULL, NULL, 1, NULL, 1, NULL, NULL, 1, NULL, NULL, NULL, '\{\\"noon\\": [], \\"morning\\": [\\"2020-02-04\\"], \\"afternoon\\": []\}', 4, 1, 1, 1, 1, 1, 1, 'no', 0, NULL, NULL, NULL, '/users/agent/r/third-step/two/', NULL, 0, 0, NULL, 0, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, 2, NULL, NULL, NULL, '2020-02-02 03:30:19', '2020-02-10 13:23:32', NULL, 'LONG_STAY', 0, 0, 0, 1, 9, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `properties_for`\
--\
\
CREATE TABLE `properties_for` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `type` tinyint(1) NOT NULL DEFAULT '0'\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `properties_for`\
--\
\
INSERT INTO `properties_for` (`id`, `name`, `type`) VALUES\
(1, 'Local de Belleza / Peluquer\'edas', 1),\
(2, 'Mini-Market', 1),\
(3, 'Distribuidoras', 1),\
(4, 'Caf\'e9s', 1),\
(5, 'Oficinas Administrativas', 1),\
(6, 'Restaurantes', 1),\
(7, 'Oficina de Ventas', 1),\
(8, 'Discotecas', 1),\
(9, 'Ensambladoras', 1),\
(10, 'Boutiques', 1),\
(11, 'Locales Comerciales de Todo Tipo', 1),\
(12, 'Otros', 1),\
(13, 'Soltero', 0),\
(14, 'Estudiante', 0),\
(15, 'Familia Sin Hijos', 0),\
(16, 'Familia Con Hijos', 0),\
(17, 'Familia Con Mascotas', 0),\
(18, 'Ejecutivos', 0),\
(19, 'Grupos +5', 0);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `properties_has_amenities`\
--\
\
CREATE TABLE `properties_has_amenities` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `amenity_id` int(10) UNSIGNED NOT NULL,\
  `property_id` int(10) UNSIGNED NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `properties_has_amenities`\
--\
\
INSERT INTO `properties_has_amenities` (`id`, `amenity_id`, `property_id`) VALUES\
(1, 5, 7),\
(2, 7, 7),\
(3, 11, 7),\
(4, 1, 7),\
(5, 2, 7),\
(6, 32, 7),\
(7, 43, 7),\
(8, 68, 7),\
(9, 69, 7),\
(10, 71, 7);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `properties_has_properties_for`\
--\
\
CREATE TABLE `properties_has_properties_for` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `property_id` int(10) UNSIGNED NOT NULL,\
  `property_for_id` int(10) UNSIGNED NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `properties_has_properties_for`\
--\
\
INSERT INTO `properties_has_properties_for` (`id`, `property_id`, `property_for_id`) VALUES\
(1, 1, 2),\
(2, 2, 2),\
(3, 3, 1),\
(4, 4, 6),\
(5, 6, 16),\
(6, 6, 17),\
(7, 7, 15),\
(8, 7, 16);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `properties_types`\
--\
\
CREATE TABLE `properties_types` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `enabled` tinyint(1) DEFAULT '1'\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `properties_types`\
--\
\
INSERT INTO `properties_types` (`id`, `name`, `enabled`) VALUES\
(1, 'Bodega', 0),\
(2, 'Estacionamiento', 0),\
(3, 'Casa', 1),\
(4, 'Departamento', 1),\
(5, 'Habitaci\'f3n', 1),\
(6, 'Local Comercial', 0),\
(7, 'Oficina', 0),\
(8, 'Terreno', 1);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `providers`\
--\
\
CREATE TABLE `providers` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `providers`\
--\
\
INSERT INTO `providers` (`id`, `name`) VALUES\
(1, 'facebook');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `regions`\
--\
\
CREATE TABLE `regions` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `country_id` int(10) UNSIGNED NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `regions`\
--\
\
INSERT INTO `regions` (`id`, `name`, `country_id`) VALUES\
(1, 'Arica y Parinacota', 39),\
(2, 'Tarapac\'e1', 39),\
(3, 'Antofagasta', 39),\
(4, 'Atacama', 39),\
(5, 'Coquimbo', 39),\
(6, 'Valparaiso', 39),\
(7, 'Metropolitana de Santiago', 39),\
(8, 'Libertador General Bernardo O\\'Higgins', 39),\
(9, 'Maule', 39),\
(10, 'Biob\'edo', 39),\
(11, 'La Araucan\'eda', 39),\
(12, 'Los R\'edos', 39),\
(13, 'Los Lagos', 39),\
(14, 'Ais\'e9n del General Carlos Ib\'e1\'f1ez del Campo', 39),\
(15, 'Magallanes y de la Ant\'e1rtica Chilena', 39),\
(16, 'Vargas', 196),\
(17, 'Trujillo', 196),\
(18, 'T\'e1chira', 196),\
(19, 'Sucre', 196),\
(20, 'Portuguesa', 196),\
(21, 'Nueva Esparta', 196),\
(22, 'Monagas', 196),\
(23, 'Miranda', 196),\
(24, 'M\'e9rida', 196),\
(25, 'Lara', 196),\
(26, 'Gu\'e1rico', 196),\
(27, 'Falc\'f3n', 196),\
(28, 'Delta Amacuro', 196),\
(29, 'Cojedes', 196),\
(30, 'Carabobo', 196),\
(31, 'Bol\'edvar', 196),\
(32, 'Barinas', 196),\
(33, 'Aragua', 196),\
(34, 'Apure', 196),\
(35, 'Anzo\'e1tegui', 196),\
(36, 'Amazonas', 196),\
(37, 'Yaracuy', 196),\
(38, 'Zulia', 196),\
(39, 'Distrito Capital', 196),\
(40, 'Amazonas', 43),\
(41, 'Antioquia', 43),\
(42, 'Arauca', 43),\
(43, 'Atl\'e1ntico', 43),\
(44, 'Bol\'edvar', 43),\
(45, 'Boyac\'e1', 43),\
(46, 'Caldas', 43),\
(47, 'Caquet\'e1', 43),\
(48, 'Casanare', 43),\
(49, 'Cauca', 43),\
(50, 'Cesar', 43),\
(51, 'Choc\'f3', 43),\
(52, 'Cundinamarca', 43),\
(53, 'C\'f3rdoba', 43),\
(54, 'Guain\'eda', 43),\
(55, 'Guaviare', 43),\
(56, 'Huila', 43),\
(57, 'La Guajira', 43),\
(58, 'Magdalena', 43),\
(59, 'Meta', 43),\
(60, 'Nari\'f1o', 43),\
(61, 'Norte de Santander', 43),\
(62, 'Putumayo', 43),\
(63, 'Quind\'edo', 43),\
(64, 'Risaralda', 43),\
(65, 'San Andr\'e9s y Providencia', 43),\
(66, 'Santander', 43),\
(67, 'Sucre', 43),\
(68, 'Tolima', 43),\
(69, 'Valle del Cauca', 43),\
(70, 'Vaup\'e9s', 43),\
(71, 'Vichada', 43),\
(72, 'Aguascalientes', 122),\
(73, 'Baja California', 122),\
(74, 'Baja California Sur', 122),\
(75, 'Campeche', 122),\
(76, 'Chiapas', 122),\
(77, 'Chihuahua', 122),\
(78, 'Coahuila', 122),\
(79, 'Colima', 122),\
(80, 'Distrito Federal', 122),\
(81, 'Durango', 122),\
(82, 'Estado de Mexico', 122),\
(83, 'Guanajuato', 122),\
(84, 'Guerrero', 122),\
(85, 'Hidalgo', 122),\
(86, 'Jalisco', 122),\
(87, 'Michoacan', 122),\
(88, 'Morelos', 122),\
(89, 'Nayarit', 122),\
(90, 'Nuevo Leon', 122),\
(91, 'Oaxaca', 122),\
(92, 'Puebla', 122),\
(93, 'Queretaro', 122),\
(94, 'Quintana Roo', 122),\
(95, 'San Luis Potosi', 122),\
(96, 'Sinaloa', 122),\
(97, 'Sonora', 122),\
(98, 'Tabasco', 122),\
(99, 'Tamaulipas', 122),\
(100, 'Tlaxcala', 122),\
(101, 'Veracruz', 122),\
(102, 'Yucatan', 122),\
(103, 'Zacatecas', 122),\
(104, 'Salta', 9),\
(105, 'Buenos Aires', 9),\
(106, 'San Luis', 9),\
(107, 'Entre R\'edos', 9),\
(108, 'La Rioja', 9),\
(109, 'Santiago del Estero', 9),\
(110, 'Chaco', 9),\
(111, 'San Juan', 9),\
(112, 'Catamarca', 9),\
(113, 'La Pampa', 9),\
(114, 'Mendoza', 9),\
(115, 'Misiones', 9),\
(116, 'Formosa', 9),\
(117, 'Neuqu\'e9n', 9),\
(118, 'R\'edo Negro', 9),\
(119, 'Santa Fe', 9),\
(120, 'Tucum\'e1n', 9),\
(121, 'Chubut', 9),\
(122, 'Tierra del Fuego, Ant\'e1rtida e Islas del Atl\'e1ntico Sur', 9),\
(123, 'Corrientes', 9),\
(124, 'C\'f3rdoba', 9),\
(125, 'Jujuy', 9),\
(126, 'Santa Cruz', 9),\
(127, 'Capital Federal', 9);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `roles`\
--\
\
CREATE TABLE `roles` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `hidden` tinyint(1) NOT NULL DEFAULT '0',\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `roles`\
--\
\
INSERT INTO `roles` (`id`, `name`, `slug`, `hidden`, `created_at`, `updated_at`) VALUES\
(1, 'Arrendatario', 'tenants', 0, NULL, NULL),\
(2, 'Propietario', 'owners', 0, NULL, NULL),\
(3, 'Agente', 'agents', 0, NULL, NULL),\
(4, 'Servicio', 'services', 0, NULL, NULL),\
(5, 'Aval', 'collaterals', 1, NULL, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `sasapplicants`\
--\
\
CREATE TABLE `sasapplicants` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `tokenSas` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `applicant_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `inspection_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `correlation_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `external_user_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `review_answer` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `review_reject_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `review_moderation_comment` text COLLATE utf8mb4_unicode_ci,\
  `review_client_comment` text COLLATE utf8mb4_unicode_ci,\
  `review_status` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `user_id` int(10) UNSIGNED NOT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `sasapplicants`\
--\
\
INSERT INTO `sasapplicants` (`id`, `tokenSas`, `applicant_id`, `inspection_id`, `correlation_id`, `external_user_id`, `type`, `review_answer`, `review_reject_type`, `review_moderation_comment`, `review_client_comment`, `review_status`, `user_id`, `created_at`, `updated_at`) VALUES\
(1, NULL, '5cb744200a975a67ed1798a4', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2020-01-21 00:12:34', '2020-01-21 00:12:34');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `schedules`\
--\
\
CREATE TABLE `schedules` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `schedule_date` date DEFAULT NULL,\
  `schedule_range` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `schedule_state` tinyint(4) DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `scoring`\
--\
\
CREATE TABLE `scoring` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '',\
  `description` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT ''\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `scoring`\
--\
\
INSERT INTO `scoring` (`id`, `name`, `description`) VALUES\
(1, 'Usuario', 'Scoring de Arrendatario'),\
(2, 'Scoring de Propiedad', 'Scoring de propiedad');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `services_list`\
--\
\
CREATE TABLE `services_list` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `service_type_id` int(10) UNSIGNED DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `services_list`\
--\
\
INSERT INTO `services_list` (`id`, `name`, `service_type_id`) VALUES\
(1, 'Carpinteria', 1),\
(2, 'Contratista Maestro Obra Reparaciones Generales', 1),\
(3, 'Electricista', 1),\
(4, 'Excavaciones y movimiento de tierra', 1),\
(5, 'Contratista de canaletas/ Reparaciones Techos', 1),\
(6, 'Jardineria', 1),\
(7, 'Contratista de pisos / Ceramica', 1),\
(8, 'Climatizaci\'f3n', 1),\
(9, 'Impermebealizacion', 1),\
(10, 'Pintura de Paredes y Techos', 1),\
(11, 'Remodelador de Cocina y Ba\'f1os', 1),\
(12, 'Construcci\'f3n de Piscinas & Mantenimiento Piscinas', 1),\
(13, 'Construcci\'f3n de Obras', 1),\
(14, 'Instalaci\'f3n Puertas y Ventanas', 1),\
(15, 'Instalaci\'f3n y Reparaci\'f3n de Gabinetes y closets', 1),\
(16, 'Paisajistas', 1),\
(17, 'Instalaci\'f3n de Pisos Flotantes', 1),\
(18, 'Experto Instalaci\'f3n de Malla de Seguridad', 1),\
(19, 'Limpieza de Alfombras', 1),\
(20, 'Instalaci\'f3n de Lamparas', 1),\
(21, 'Gasfisteria', 1),\
(22, 'Instalacion de alarmas y sistema de seguridad perimetral', 1),\
(23, 'Tapiceria y reparaci\'f3n de Muebles', 1),\
(24, 'Otras reparaciones', 1),\
(25, 'Asesora de Hogar Puertas Afuera', 2),\
(26, 'Asesora Hogar Puertas Adentro', 2),\
(27, 'Control de Plagas', 2),\
(28, 'Confeccionista Cortinas', 2),\
(29, 'Vigilantes y Guardia de Seguridad', 2),\
(30, 'Decorador de Interiores', 2),\
(31, 'Servicio de mudanzas', 2),\
(32, 'Otros Servicios en General', 2),\
(33, 'Profesores Particulares Educaci\'f3n General', 3),\
(34, 'Nutricionistas', 3),\
(35, 'Cuidador de Adulto Mayor', 3),\
(36, 'Arquitectos', 3),\
(37, 'Profesionales expertos en Computaci\'f3n y Electronica Menor', 3),\
(38, 'Dise\'f1ador de interiores', 3),\
(39, 'Profesor de Gym', 3),\
(40, 'Profesor de Yoga', 3),\
(41, 'Profesor de pilates', 3),\
(42, 'Kinesiologo', 3),\
(43, 'Cocinero Chef', 3),\
(44, 'Enfermeras', 3),\
(45, 'Fonoaudiolo', 3),\
(46, 'Profesor Particular Clases Ingles', 3),\
(47, 'Profesor Particular Clases Matematica', 3),\
(48, 'Profesor Particular clases Lenguaje', 3),\
(49, 'Reposteria & Preparaci\'f3n de Tortas', 3),\
(50, 'Veterinarios', 3),\
(51, 'Otros Profesionales', 3);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `services_type`\
--\
\
CREATE TABLE `services_type` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `services_type`\
--\
\
INSERT INTO `services_type` (`id`, `name`) VALUES\
(1, 'Reparaciones Generales'),\
(2, 'Servicios al Hogar'),\
(3, 'Profesionales Carrera');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `spaces`\
--\
\
CREATE TABLE `spaces` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `spaces`\
--\
\
INSERT INTO `spaces` (`id`, `name`) VALUES\
(1, 'Planos'),\
(2, 'Living'),\
(3, 'Living / Comedor'),\
(4, 'Comedor'),\
(5, 'Cocina'),\
(6, 'Ba\'f1o Principal'),\
(7, 'Ba\'f1o Secundario'),\
(8, 'Ba\'f1o Visita'),\
(9, 'Habitaci\'f3n Principal'),\
(10, 'Habitaci\'f3n'),\
(11, 'Terraza'),\
(12, 'Jardin'),\
(13, 'Logia / Zona Lavado'),\
(14, 'Quincho'),\
(15, 'Habitaci\'f3n Servicio'),\
(16, 'Sala Estudio'),\
(17, 'Patio Trasero'),\
(18, 'Patio Delantero'),\
(19, 'Zona de Lavado'),\
(20, 'Planos'),\
(21, 'Otro');\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `useradmins`\
--\
\
CREATE TABLE `useradmins` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `photo` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `role` int(11) NOT NULL DEFAULT '1',\
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `useradmins`\
--\
\
INSERT INTO `useradmins` (`id`, `name`, `email`, `photo`, `address`, `phone`, `role`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES\
(1, 'admin', 'admin@admin.com', NULL, NULL, NULL, 1, '$2y$10$o41ozZH75dYP1nOfrBU9auT8i8I4Y4Kik7Wjv3pAQ/OL4iLR3UaUS', NULL, NULL, NULL),\
(2, 'admin uhomie', 'admin@uhomie.cl', NULL, NULL, NULL, 1, '$2y$10$pmIoQJiiuId1Gj/Xej3bSufsmUe39aAkgYpFuONE7H/GhHgtWpqEu', NULL, NULL, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `users`\
--\
\
CREATE TABLE `users` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `firstname` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `lastname` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `photo` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `birthdate` date DEFAULT NULL,\
  `phone` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `phone_code` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `authy_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `active` tinyint(1) NOT NULL DEFAULT '1',\
  `activation_token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `mail_verified` tinyint(1) NOT NULL DEFAULT '0',\
  `phone_verified` tinyint(1) NOT NULL DEFAULT '0',\
  `document_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `document_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `document_serie` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `address_details` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `latitude` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `longitude` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `tercera_clave` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `confirmed_action` tinyint(1) NOT NULL DEFAULT '0',\
  `verifyng_attempts` tinyint(4) NOT NULL DEFAULT '3',\
  `expenses_limit` int(11) DEFAULT NULL,\
  `common_expenses_limit` int(11) DEFAULT NULL,\
  `warranty_months_quantity` int(11) NOT NULL DEFAULT '0',\
  `months_advance_quantity` int(11) NOT NULL DEFAULT '0',\
  `tenanting_months_quantity` int(11) NOT NULL DEFAULT '0',\
  `move_date` date DEFAULT NULL,\
  `property_type` int(11) DEFAULT NULL,\
  `property_condition` int(11) DEFAULT NULL,\
  `property_for` int(11) DEFAULT NULL,\
  `pet_preference` varchar(5) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `furnished` tinyint(1) NOT NULL DEFAULT '0',\
  `smoking_allowed` tinyint(1) NOT NULL DEFAULT '0',\
  `employment_type` tinyint(4) NOT NULL DEFAULT '0',\
  `position` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `company` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `worked_from_date` date DEFAULT NULL,\
  `worked_to_date` date DEFAULT NULL,\
  `job_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `amount` int(11) NOT NULL DEFAULT '0',\
  `saves` tinyint(1) NOT NULL DEFAULT '0',\
  `save_amount` int(11) DEFAULT NULL,\
  `afp` tinyint(1) DEFAULT NULL,\
  `invoice` tinyint(1) DEFAULT NULL,\
  `last_invoice_amount` int(11) NOT NULL DEFAULT '0',\
  `other_income_type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '0',\
  `other_income_amount` int(11) DEFAULT NULL,\
  `profile_picture` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `created_by_reference` tinyint(1) NOT NULL DEFAULT '0',\
  `confirmed_collateral` tinyint(1) NOT NULL DEFAULT '0',\
  `tenanting_insurance` tinyint(1) NOT NULL DEFAULT '0',\
  `agent_profile_redirect` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `owner_profile_redirect` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `tenant_profile_redirect` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `service_profile_redirect` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `collateral_profile_redirect` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `account_type` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `account_number` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `show_welcome` tinyint(1) NOT NULL DEFAULT '1',\
  `faceid_videoindexer` text COLLATE utf8mb4_unicode_ci,\
  `personid_videoindexer` text COLLATE utf8mb4_unicode_ci,\
  `country_id` int(10) UNSIGNED DEFAULT NULL,\
  `civil_status_id` int(10) UNSIGNED DEFAULT NULL,\
  `collateral_id` int(10) UNSIGNED DEFAULT NULL,\
  `city_id` int(10) UNSIGNED DEFAULT NULL,\
  `bank_id` int(10) UNSIGNED DEFAULT NULL,\
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `deleted_at` timestamp NULL DEFAULT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL,\
  `api_token` varchar(60) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `short_stay` tinyint(1) NOT NULL DEFAULT '0',\
  `long_stay` tinyint(1) NOT NULL DEFAULT '0'\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `users`\
--\
\
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `password`, `photo`, `birthdate`, `phone`, `phone_code`, `authy_id`, `active`, `activation_token`, `mail_verified`, `phone_verified`, `document_type`, `document_number`, `document_serie`, `address`, `address_details`, `latitude`, `longitude`, `tercera_clave`, `confirmed_action`, `verifyng_attempts`, `expenses_limit`, `common_expenses_limit`, `warranty_months_quantity`, `months_advance_quantity`, `tenanting_months_quantity`, `move_date`, `property_type`, `property_condition`, `property_for`, `pet_preference`, `furnished`, `smoking_allowed`, `employment_type`, `position`, `company`, `worked_from_date`, `worked_to_date`, `job_type`, `amount`, `saves`, `save_amount`, `afp`, `invoice`, `last_invoice_amount`, `other_income_type`, `other_income_amount`, `profile_picture`, `created_by_reference`, `confirmed_collateral`, `tenanting_insurance`, `agent_profile_redirect`, `owner_profile_redirect`, `tenant_profile_redirect`, `service_profile_redirect`, `collateral_profile_redirect`, `account_type`, `account_number`, `show_welcome`, `faceid_videoindexer`, `personid_videoindexer`, `country_id`, `civil_status_id`, `collateral_id`, `city_id`, `bank_id`, `remember_token`, `deleted_at`, `created_at`, `updated_at`, `api_token`, `short_stay`, `long_stay`) VALUES\
(1, 'Se\'f1or', 'Aval', 'uno@gmail.com', '$2y$10$5W/dp.JYoZmT82BaqqdHLuhF1W5wGj.c7EA0z/zpi6XMOLarHrmC2', '/images/avatars/user01.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 1, 1, 'PASAPORTE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, NULL, NULL, 1, 1, 8, '2020-01-21', 5, NULL, NULL, 'dog', 0, 1, 1, NULL, NULL, NULL, NULL, NULL, 900, 0, 12000, NULL, NULL, 3000, '0', 700, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 10, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(2, 'Jose', 'Gutierrez', 'dos@gmail.com', '$2y$10$ebKI2yGeRV7jOIFfuMvVQOqnqY5Zq2lKU9aAMWVZfTV28s7bf8nJy', '/images/avatars/user02.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 1, 0, 'PASAPORTE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, NULL, NULL, 1, 1, 8, '2020-01-21', 5, NULL, NULL, 'dog', 0, 1, 2, NULL, NULL, NULL, NULL, NULL, 0, 0, 12000, NULL, NULL, 3000, '0', 700, NULL, 1, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 25, 1, 1, 17, 2, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(3, 'Hannah Nitzsche', 'Miss Eryn Beer PhD', 'mayer.evie@hotmail.com', '$2y$10$6KpXAMK7rQfgdlN7a3ciO.E8kgB.ct9Hx0ZQxMf4W0By9qG1soI3y', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 1, 1, 'RUT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 781958, 397962, 1, 1, 2, '2020-02-21', 6, 0, 3, 'other', 1, 1, 3, NULL, NULL, NULL, NULL, NULL, 252635, 0, 385439, NULL, NULL, 247210, '0', 573673, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 39, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(4, 'Oral Boehm', 'Andy Blanda', 'bboyle@luettgen.com', '$2y$10$2dJfjLuSD60DaL62vd.81uOx5h86Kn3eHjXvTs04QSGBGdGLUXwtu', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 1, 1, 'PASAPORTE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 183379, 80135, 2, 2, 16, '2020-04-08', 4, 1, 2, 'dog', 1, 0, 3, NULL, NULL, NULL, NULL, NULL, 711395, 0, 776515, NULL, NULL, 706259, '0', 186398, NULL, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 12, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(5, 'Sonya Rippin', 'Dr. Missouri Schumm', 'vonrueden.gino@gmail.com', '$2y$10$b/ik/tQv8XtV2n9bp83MtOWX7CGcKhlOYh5vHQ.F9fIRLQskYhRaC', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 1, 1, 'RUT_PROVISIONAL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 306654, 273232, 1, 1, 1, '2020-05-16', 5, 0, 7, 'no', 0, 0, 3, NULL, NULL, NULL, NULL, NULL, 996735, 0, 245453, NULL, NULL, 640567, '0', 423205, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 38, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(6, 'Dr. Ashley Kilback', 'Lilliana Braun', 'shields.laurel@wehner.com', '$2y$10$BAMxXRQ1IR29NRWr5HhqUeb7QCesnYW/eg6P2ZD0OcS../LUUC9wS', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 0, 0, 'RUT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 411814, 43978, 2, 3, 18, '2020-03-30', 2, 0, 1, 'other', 1, 1, 3, NULL, NULL, NULL, NULL, NULL, 942397, 0, 978634, NULL, NULL, 690698, '0', 546719, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 11, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(7, 'Kaci Gislason', 'Eldridge Balistreri PhD', 'wiegand.allie@gmail.com', '$2y$10$ec2VAj4LbarEp7tw/tSAMe2DDjIaBM.RMEmI.WIGZx/ttkF8d1MMq', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 0, 0, 'PASAPORTE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 370116, 49954, 2, 2, 7, '2020-03-25', 5, 0, 4, 'other', 0, 0, 3, NULL, NULL, NULL, NULL, NULL, 310885, 0, 550086, NULL, NULL, 700289, '0', 846817, NULL, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(8, 'Lilla Jast', 'Amie Hegmann', 'sprosacco@little.net', '$2y$10$PcWT56Pj1895hN0VV3Eg/Oh9x.HgBn7J0awtgwFLwiXNUdsBGhOci', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 0, 0, 'PASAPORTE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 972297, 92987, 1, 2, 16, '2020-05-09', 1, 1, 3, 'cat', 1, 1, 3, NULL, NULL, NULL, NULL, NULL, 253584, 0, 578583, NULL, NULL, 395874, '0', 31743, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 33, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(9, 'Torrey Runte', 'Dawn Jenkins', 'fae45@barton.biz', '$2y$10$xwifghL37rGJLhRqOfR5TueYD1QHQUjKsPuRwkAKHtDlb9ftA6XPi', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 1, 0, 'PASAPORTE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 135624, 182790, 3, 3, 6, '2020-02-03', 4, 2, 6, 'cat', 0, 0, 3, NULL, NULL, NULL, NULL, NULL, 128671, 0, 408444, NULL, NULL, 889892, '0', 768351, NULL, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 2, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(10, 'Ms. Kyla Cronin IV', 'Adela Stoltenberg', 'braxton93@gmail.com', '$2y$10$73IMUQdvVt34BUa/aZLsm.j24LGfnQ9B2fKDUkocNjc4Ex16qIusi', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 1, 0, 'PASAPORTE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 587117, 15717, 2, 1, 22, '2020-02-06', 4, 0, 3, 'no', 1, 0, 3, NULL, NULL, NULL, NULL, NULL, 97880, 0, 61143, NULL, NULL, 192006, '0', 283499, NULL, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 31, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(11, 'Oceane Stiedemann', 'Prof. Daron Brekke', 'bmante@rau.org', '$2y$10$IWoGR7uTSyWiEc6FaRWV3uU77vs83nw8HdySLCuufYwOdO2pGgfOC', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 0, 1, 'PASAPORTE', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 627571, 512716, 1, 1, 1, '2020-05-03', 6, 1, 1, 'other', 0, 1, 3, NULL, NULL, NULL, NULL, NULL, 658568, 0, 729237, NULL, NULL, 992541, '0', 346783, NULL, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 22, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(12, 'Dr. Mossie Conroy', 'Wilfred Schuster', 'aolson@gmail.com', '$2y$10$nQLnQqvxtQFYIeGyF52gNOVwzn8Wsr00aGoRHBsirLIXHzektbNmG', '/images/avatars/user03.jpg', NULL, NULL, NULL, NULL, 1, 'ertoken', 0, 0, 'RUT', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, 445365, 541314, 1, 1, 5, '2020-03-01', 5, 0, 6, 'no', 1, 0, 3, NULL, NULL, NULL, NULL, NULL, 980806, 0, 822956, NULL, NULL, 216440, '0', 267939, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 33, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0),\
(13, 'Jon', 'Doe', 'alejandro.arancibia@uhomie.cl', '$2y$10$UBvxASCJlVdNobNSY1wTVu1kqEyk7Fprbr0kYKYseMk8lhI5iTQDu', '/images/husky.png', '1995-06-04', '9774314920', '56', '140848496', 1, 'hxv5721per46mjty5d929c0aqz33lkofsn1gc32cu8w1bidc8', 1, 1, 'RUT', '8.476.690-9', NULL, 'Condell 114, Limache, Chile', 'segundo piso', '-32.984233', '-71.2745885', NULL, 0, 3, 320000, 60000, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, 0, '0', NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 'Cuenta Corriente', '23232323', 1, NULL, NULL, 39, 1, NULL, 57, 1, 'eK5pFDvCbxSYhllvL0QvbQeIC1k0ajoeo3Gbv4HJruQdy2KH0pfUuXzai8Jq', NULL, NULL, NULL, NULL, 0, 0),\
(14, 'Alejandro', 'Arancibia', 'alexandrox4@gmail.com', '$2y$10$JrVAq98mWImyEWXa9rHDTOWCdhkj/hhxH275ltDAiBHQPNrwUa12.', '/images/husky.png', '1995-06-04', '9343305980', '56', '146697545', 1, 'ad3te50zw4j7i4k8yg1rs5n88uh12oxqdccef98dapc6lvm1b', 1, 1, 'RUT', '19.150.812-2', NULL, 'Condell 114, Limache, Chile', 'segundo piso', '-32.984233', '-71.2745885', NULL, 0, 3, 320000, 60000, 1, 1, 8, '2019-07-01', 5, 2, 1, 'no', 0, 0, 1, 'dev', 'uhomie', '2019-06-30', NULL, 'FullTime', 1000000, 0, 0, 0, NULL, 0, '0', 0, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 39, 1, NULL, 57, NULL, 'eK5pFDvCbxSYhllvL0QvbQeIC1k0ajoeo3Gbv4HJruQdy2KH0pfUuXzai8Jq', NULL, NULL, NULL, NULL, 0, 0),\
(15, 'Lauren', 'Bond', 'laurenb2282@gmail.com', '$2y$10$UtI8nCagpliqwT3brVdqve4KtqGMhjbbsHieDSHA06bRuIsnAgYmW', NULL, NULL, NULL, NULL, NULL, 1, 'a06nv74x0eoi9r2mbc3u28eph6jdzlf1wkfqe6s954ag45yct', 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, 3, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, 0, '0', NULL, NULL, 0, 0, 0, NULL, NULL, 'users.tenants.first-step', NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ETOdfnxYQOescqvN8wVcX5ll6UeaP5jx3vOcW4T0IEgznflfyXByGsoePMUZ', NULL, '2020-01-21 00:15:02', '2020-02-03 06:40:46', NULL, 0, 1),\
(16, 'William', 'Jackson', 'uearngold@outlook.com', '$2y$10$UtI8nCagpliqwT3brVdqve4KtqGMhjbbsHieDSHA06bRuIsnAgYmW', NULL, '2002-02-01', NULL, NULL, NULL, 1, 'bxdkojarcuhe4i52y8s5mn5l2paf0vw0tq5f1e8c574839zg6', 1, 1, 'RUT', '56.235.489.275-6', NULL, 'Avenida Libertador Bernardo O\\'Higgins, Santiago, Chile', 'aaasdasdasd', '-33.4491254', '-70.67292549999999', NULL, 0, 3, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, 0, '0', NULL, NULL, 0, 0, 0, NULL, NULL, 'users.tenants.second-step', NULL, NULL, 'Cuenta Corriente', '12313123123', 1, NULL, NULL, 1, 1, NULL, 4, 1, 'B74QJgzYCALvY79SpjU9FOy1ThNg6xlABjbMIHN8UF5nZV88EbIviu0iEZzN', NULL, '2020-01-22 12:18:36', '2020-02-02 03:13:55', NULL, 0, 0),\
(17, 'test', 'test', 'ty_dev88@outlook.com', '$2y$10$UtI8nCagpliqwT3brVdqve4KtqGMhjbbsHieDSHA06bRuIsnAgYmW', NULL, '2002-02-01', NULL, NULL, NULL, 1, 'b06ucpq0h9c33yme03wnadtlrg56216bj75k18se4ofxzbi9v', 1, 1, 'RUT', '', NULL, 'Avenida 10 de Julio, Santiago, Chile', 'werwerwer', '-33.45328369999999', '-70.64398299999999', NULL, 0, 3, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, 0, '0', NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 'Cuenta de Ahorro', '123123123123', 1, NULL, NULL, 1, 1, NULL, 2, 1, '1Xs5HxniA2pHxiCIGn5G8lHyCgydcjHHvjBjy6VFy2STEOkObdJXACzyyK0D', NULL, '2020-02-02 03:26:11', '2020-02-02 03:53:45', NULL, 0, 0),\
(23, 'jacok', 'smith', 'janakpadhya57@gmail.com', '$2y$10$0bRdkCb3n2WqVYqOPaZm4eUw/7Jte/rmKXM8AuuW9qnzY7VKFxyce', NULL, '2002-02-06', NULL, NULL, NULL, 1, '29e1q837by3dpeekhc7at98os4vrfxc6ize4gl9wu2nm355j0', 1, 1, 'RUT', '56.654-3', NULL, 'Avenida 10 de Julio, Santiago, Chile', 'werwerwer', '-33.45328369999999', '-70.64398299999999', NULL, 0, 3, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, 0, '0', NULL, NULL, 0, 0, 0, NULL, NULL, 'users.tenants.second-step', NULL, NULL, NULL, NULL, 1, NULL, NULL, 1, 1, NULL, 4, NULL, 'ZNG7tuHsDH77vEPgLqzArzLuNsDGLkblIkZ0oq1S4Rlk0R6QBHlPM3mmVdFu', NULL, '2020-02-03 17:49:23', '2020-02-09 00:40:18', NULL, 0, 1);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `users_has_amenities`\
--\
\
CREATE TABLE `users_has_amenities` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `amenity_id` int(10) UNSIGNED NOT NULL,\
  `user_id` int(10) UNSIGNED NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `users_has_contracts`\
--\
\
CREATE TABLE `users_has_contracts` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `user_id` int(10) UNSIGNED NOT NULL,\
  `contract_id` int(10) UNSIGNED NOT NULL,\
  `order` int(10) UNSIGNED DEFAULT NULL,\
  `status_code` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'awaiting_signature',\
  `signature_id` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `signer_email_address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `signer_name` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `signed_at` datetime DEFAULT NULL,\
  `last_viewed_at` datetime DEFAULT NULL,\
  `last_reminded_at` datetime DEFAULT NULL,\
  `has_pin` tinyint(1) DEFAULT NULL,\
  `signer_pin` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `signer_role` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `ip_address` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,\
  `auditory_file` text COLLATE utf8mb4_unicode_ci,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `users_has_coupons`\
--\
\
CREATE TABLE `users_has_coupons` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `user_id` int(10) UNSIGNED NOT NULL,\
  `coupon_id` int(10) UNSIGNED NOT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `users_has_memberships`\
--\
\
CREATE TABLE `users_has_memberships` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `membership_id` int(10) UNSIGNED DEFAULT NULL,\
  `user_id` int(10) UNSIGNED DEFAULT NULL,\
  `purchased_at` datetime DEFAULT NULL,\
  `expires_at` datetime DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `users_has_memberships`\
--\
\
INSERT INTO `users_has_memberships` (`id`, `membership_id`, `user_id`, `purchased_at`, `expires_at`) VALUES\
(1, 1, 2, NULL, NULL),\
(2, 2, 3, NULL, NULL),\
(3, 3, 4, NULL, NULL),\
(4, 1, 5, NULL, NULL),\
(5, 3, 6, NULL, NULL),\
(6, 3, 7, NULL, NULL),\
(7, 2, 8, NULL, NULL),\
(8, 2, 9, NULL, NULL),\
(9, 2, 10, NULL, NULL),\
(10, 1, 11, NULL, NULL),\
(11, 5, 7, NULL, NULL),\
(12, 6, 8, NULL, NULL),\
(13, 7, 9, NULL, NULL),\
(14, 10, 4, NULL, NULL),\
(15, 13, 4, NULL, NULL),\
(16, 5, 13, NULL, NULL),\
(17, 1, 14, NULL, NULL),\
(18, 4, 15, NULL, NULL),\
(20, 5, 16, '2020-02-01 18:50:13', '2020-03-02 18:50:13'),\
(21, 4, 16, NULL, NULL),\
(23, 5, 17, '2020-02-01 19:53:40', '2020-03-02 19:53:40'),\
(24, 4, 23, NULL, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `users_has_notifications`\
--\
\
CREATE TABLE `users_has_notifications` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `notification_id` int(10) UNSIGNED NOT NULL,\
  `user_id` int(10) UNSIGNED NOT NULL,\
  `active` tinyint(1) NOT NULL DEFAULT '1',\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL,\
  `deleted_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `users_has_notifications`\
--\
\
INSERT INTO `users_has_notifications` (`id`, `notification_id`, `user_id`, `active`, `created_at`, `updated_at`, `deleted_at`) VALUES\
(1, 2, 16, 1, NULL, NULL, NULL),\
(2, 4, 16, 1, NULL, NULL, NULL),\
(3, 5, 16, 1, NULL, NULL, NULL),\
(4, 6, 16, 1, NULL, NULL, NULL),\
(5, 7, 16, 1, NULL, NULL, NULL),\
(6, 8, 16, 1, NULL, NULL, NULL),\
(7, 9, 16, 1, NULL, NULL, NULL),\
(8, 10, 16, 1, NULL, NULL, NULL),\
(9, 11, 16, 1, NULL, NULL, NULL),\
(10, 12, 16, 1, NULL, NULL, NULL),\
(11, 2, 17, 1, NULL, NULL, NULL),\
(12, 4, 17, 1, NULL, NULL, NULL),\
(13, 5, 17, 1, NULL, NULL, NULL),\
(14, 6, 17, 1, NULL, NULL, NULL),\
(15, 7, 17, 1, NULL, NULL, NULL),\
(16, 8, 17, 1, NULL, NULL, NULL),\
(17, 9, 17, 1, NULL, NULL, NULL),\
(18, 10, 17, 1, NULL, NULL, NULL),\
(19, 11, 17, 1, NULL, NULL, NULL),\
(20, 12, 17, 1, NULL, NULL, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `users_has_postulates_days`\
--\
\
CREATE TABLE `users_has_postulates_days` (\
  `id` bigint(20) UNSIGNED NOT NULL,\
  `days` text COLLATE utf8mb4_unicode_ci NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `users_has_privacies`\
--\
\
CREATE TABLE `users_has_privacies` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `privacy_id` int(10) UNSIGNED NOT NULL,\
  `user_id` int(10) UNSIGNED NOT NULL,\
  `active` tinyint(1) NOT NULL DEFAULT '1',\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL,\
  `deleted_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `users_has_privacies`\
--\
\
INSERT INTO `users_has_privacies` (`id`, `privacy_id`, `user_id`, `active`, `created_at`, `updated_at`, `deleted_at`) VALUES\
(1, 5, 16, 1, NULL, NULL, NULL),\
(2, 6, 16, 1, NULL, NULL, NULL),\
(3, 7, 16, 1, NULL, NULL, NULL),\
(4, 5, 17, 1, NULL, NULL, NULL),\
(5, 6, 17, 1, NULL, NULL, NULL),\
(6, 7, 17, 1, NULL, NULL, NULL);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `users_has_properties`\
--\
\
CREATE TABLE `users_has_properties` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `type` tinyint(4) NOT NULL,\
  `property_id` int(10) UNSIGNED NOT NULL,\
  `user_id` int(10) UNSIGNED NOT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `users_has_properties`\
--\
\
INSERT INTO `users_has_properties` (`id`, `type`, `property_id`, `user_id`) VALUES\
(1, 1, 1, 7),\
(2, 1, 2, 8),\
(3, 1, 3, 9),\
(4, 3, 3, 4),\
(5, 3, 3, 5),\
(6, 3, 3, 6),\
(7, 2, 3, 6),\
(8, 2, 1, 7),\
(9, 2, 2, 8),\
(10, 2, 2, 7),\
(11, 2, 1, 11),\
(12, 2, 2, 3),\
(13, 2, 3, 9),\
(14, 2, 1, 2),\
(15, 2, 1, 6),\
(16, 2, 2, 5),\
(17, 2, 3, 6),\
(18, 2, 2, 5),\
(19, 2, 2, 6),\
(20, 2, 3, 1),\
(21, 2, 3, 4),\
(22, 2, 3, 11),\
(23, 2, 1, 3),\
(24, 2, 1, 10),\
(25, 2, 2, 2),\
(26, 2, 2, 11),\
(27, 2, 2, 11),\
(28, 1, 5, 13),\
(29, 1, 6, 16),\
(30, 1, 7, 17);\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `user_provider`\
--\
\
CREATE TABLE `user_provider` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `user_provider_id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,\
  `user_id` int(10) UNSIGNED DEFAULT NULL,\
  `provider_id` int(10) UNSIGNED DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
-- --------------------------------------------------------\
\
--\
-- Table structure for table `visits`\
--\
\
CREATE TABLE `visits` (\
  `id` int(10) UNSIGNED NOT NULL,\
  `property_id` int(10) UNSIGNED NOT NULL,\
  `created_at` timestamp NULL DEFAULT NULL,\
  `updated_at` timestamp NULL DEFAULT NULL\
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;\
\
--\
-- Dumping data for table `visits`\
--\
\
INSERT INTO `visits` (`id`, `property_id`, `created_at`, `updated_at`) VALUES\
(1, 3, '2020-02-02 03:00:11', '2020-02-02 03:00:11'),\
(2, 3, '2020-02-02 03:02:53', '2020-02-02 03:02:53'),\
(3, 6, '2020-02-02 03:05:18', '2020-02-02 03:05:18'),\
(4, 6, '2020-02-02 03:06:06', '2020-02-02 03:06:06'),\
(5, 6, '2020-02-02 03:08:08', '2020-02-02 03:08:08'),\
(6, 7, '2020-02-02 03:56:12', '2020-02-02 03:56:12'),\
(7, 7, '2020-02-03 06:12:38', '2020-02-03 06:12:38'),\
(8, 7, '2020-02-03 06:13:39', '2020-02-03 06:13:39'),\
(9, 3, '2020-02-03 06:17:42', '2020-02-03 06:17:42'),\
(10, 7, '2020-02-03 06:40:24', '2020-02-03 06:40:24'),\
(11, 7, '2020-02-03 06:42:11', '2020-02-03 06:42:11'),\
(12, 7, '2020-02-03 15:45:22', '2020-02-03 15:45:22'),\
(13, 7, '2020-02-03 15:58:10', '2020-02-03 15:58:10'),\
(14, 7, '2020-02-03 17:21:31', '2020-02-03 17:21:31'),\
(15, 7, '2020-02-03 17:26:46', '2020-02-03 17:26:46'),\
(16, 7, '2020-02-03 17:59:07', '2020-02-03 17:59:07'),\
(17, 7, '2020-02-03 18:00:41', '2020-02-03 18:00:41'),\
(18, 1, '2020-02-03 19:08:45', '2020-02-03 19:08:45'),\
(19, 1, '2020-02-03 19:26:34', '2020-02-03 19:26:34'),\
(20, 1, '2020-02-03 19:29:07', '2020-02-03 19:29:07'),\
(21, 1, '2020-02-03 19:29:34', '2020-02-03 19:29:34'),\
(22, 1, '2020-02-03 19:40:57', '2020-02-03 19:40:57'),\
(23, 7, '2020-02-03 22:08:56', '2020-02-03 22:08:56'),\
(24, 7, '2020-02-03 22:23:12', '2020-02-03 22:23:12'),\
(25, 7, '2020-02-03 22:25:52', '2020-02-03 22:25:52'),\
(26, 7, '2020-02-03 22:26:27', '2020-02-03 22:26:27'),\
(27, 3, '2020-02-04 07:31:35', '2020-02-04 07:31:35'),\
(28, 3, '2020-02-04 07:54:32', '2020-02-04 07:54:32'),\
(29, 3, '2020-02-04 07:56:23', '2020-02-04 07:56:23'),\
(30, 3, '2020-02-04 07:56:59', '2020-02-04 07:56:59'),\
(31, 3, '2020-02-04 09:13:47', '2020-02-04 09:13:47'),\
(32, 3, '2020-02-04 09:16:58', '2020-02-04 09:16:58'),\
(33, 3, '2020-02-04 09:19:18', '2020-02-04 09:19:18'),\
(34, 3, '2020-02-04 09:20:36', '2020-02-04 09:20:36'),\
(35, 3, '2020-02-04 09:21:35', '2020-02-04 09:21:35'),\
(36, 3, '2020-02-04 09:25:17', '2020-02-04 09:25:17'),\
(37, 3, '2020-02-04 09:25:48', '2020-02-04 09:25:48'),\
(38, 3, '2020-02-04 09:27:27', '2020-02-04 09:27:27'),\
(39, 3, '2020-02-04 09:34:43', '2020-02-04 09:34:43'),\
(40, 3, '2020-02-04 09:35:04', '2020-02-04 09:35:04'),\
(41, 3, '2020-02-04 09:35:06', '2020-02-04 09:35:06'),\
(42, 3, '2020-02-04 09:36:22', '2020-02-04 09:36:22'),\
(43, 3, '2020-02-04 10:14:32', '2020-02-04 10:14:32'),\
(44, 3, '2020-02-04 10:15:50', '2020-02-04 10:15:50'),\
(45, 3, '2020-02-04 10:19:58', '2020-02-04 10:19:58'),\
(46, 3, '2020-02-04 10:20:29', '2020-02-04 10:20:29'),\
(47, 3, '2020-02-04 10:22:28', '2020-02-04 10:22:28'),\
(48, 3, '2020-02-04 10:22:45', '2020-02-04 10:22:45'),\
(49, 3, '2020-02-04 10:25:10', '2020-02-04 10:25:10'),\
(50, 3, '2020-02-04 10:27:50', '2020-02-04 10:27:50'),\
(51, 3, '2020-02-04 10:27:54', '2020-02-04 10:27:54'),\
(52, 3, '2020-02-04 10:29:33', '2020-02-04 10:29:33'),\
(53, 3, '2020-02-04 10:32:42', '2020-02-04 10:32:42'),\
(54, 3, '2020-02-04 10:40:03', '2020-02-04 10:40:03'),\
(55, 3, '2020-02-04 10:40:20', '2020-02-04 10:40:20'),\
(56, 3, '2020-02-04 10:40:45', '2020-02-04 10:40:45'),\
(57, 3, '2020-02-04 10:43:53', '2020-02-04 10:43:53'),\
(58, 3, '2020-02-04 10:45:45', '2020-02-04 10:45:45'),\
(59, 3, '2020-02-04 10:46:05', '2020-02-04 10:46:05'),\
(60, 3, '2020-02-04 10:46:35', '2020-02-04 10:46:35'),\
(61, 3, '2020-02-04 10:46:56', '2020-02-04 10:46:56'),\
(62, 3, '2020-02-04 10:47:04', '2020-02-04 10:47:04'),\
(63, 3, '2020-02-04 10:47:29', '2020-02-04 10:47:29'),\
(64, 3, '2020-02-04 10:50:38', '2020-02-04 10:50:38'),\
(65, 3, '2020-02-04 10:51:25', '2020-02-04 10:51:25'),\
(66, 3, '2020-02-04 10:51:52', '2020-02-04 10:51:52'),\
(67, 3, '2020-02-04 10:52:19', '2020-02-04 10:52:19'),\
(68, 3, '2020-02-04 10:52:27', '2020-02-04 10:52:27'),\
(69, 3, '2020-02-04 10:52:50', '2020-02-04 10:52:50'),\
(70, 3, '2020-02-04 10:52:58', '2020-02-04 10:52:58'),\
(71, 3, '2020-02-04 10:57:17', '2020-02-04 10:57:17'),\
(72, 3, '2020-02-04 10:57:44', '2020-02-04 10:57:44'),\
(73, 3, '2020-02-04 10:58:53', '2020-02-04 10:58:53'),\
(74, 3, '2020-02-04 10:59:30', '2020-02-04 10:59:30'),\
(75, 3, '2020-02-04 11:00:01', '2020-02-04 11:00:01'),\
(76, 3, '2020-02-04 12:19:08', '2020-02-04 12:19:08'),\
(77, 3, '2020-02-04 12:26:10', '2020-02-04 12:26:10'),\
(78, 3, '2020-02-04 12:29:02', '2020-02-04 12:29:02'),\
(79, 3, '2020-02-04 12:29:31', '2020-02-04 12:29:31'),\
(80, 3, '2020-02-04 12:30:22', '2020-02-04 12:30:22'),\
(81, 3, '2020-02-04 12:31:08', '2020-02-04 12:31:08'),\
(82, 3, '2020-02-04 12:36:20', '2020-02-04 12:36:20'),\
(83, 3, '2020-02-04 12:37:13', '2020-02-04 12:37:13'),\
(84, 3, '2020-02-04 12:38:02', '2020-02-04 12:38:02'),\
(85, 3, '2020-02-04 12:38:44', '2020-02-04 12:38:44'),\
(86, 7, '2020-02-04 12:44:36', '2020-02-04 12:44:36'),\
(87, 3, '2020-02-04 12:56:41', '2020-02-04 12:56:41'),\
(88, 3, '2020-02-04 12:58:12', '2020-02-04 12:58:12'),\
(89, 3, '2020-02-04 12:58:40', '2020-02-04 12:58:40'),\
(90, 3, '2020-02-04 12:59:05', '2020-02-04 12:59:05'),\
(91, 3, '2020-02-04 13:00:43', '2020-02-04 13:00:43'),\
(92, 3, '2020-02-04 13:01:19', '2020-02-04 13:01:19'),\
(93, 3, '2020-02-04 13:02:45', '2020-02-04 13:02:45'),\
(94, 3, '2020-02-04 13:07:04', '2020-02-04 13:07:04'),\
(95, 3, '2020-02-04 13:17:36', '2020-02-04 13:17:36'),\
(96, 3, '2020-02-04 13:19:09', '2020-02-04 13:19:09'),\
(97, 3, '2020-02-04 13:31:01', '2020-02-04 13:31:01'),\
(98, 3, '2020-02-04 13:34:49', '2020-02-04 13:34:49'),\
(99, 3, '2020-02-04 13:36:08', '2020-02-04 13:36:08'),\
(100, 3, '2020-02-04 14:20:29', '2020-02-04 14:20:29'),\
(101, 3, '2020-02-04 14:30:09', '2020-02-04 14:30:09'),\
(102, 3, '2020-02-04 14:31:18', '2020-02-04 14:31:18'),\
(103, 3, '2020-02-04 14:32:28', '2020-02-04 14:32:28'),\
(104, 3, '2020-02-04 14:32:31', '2020-02-04 14:32:31'),\
(105, 3, '2020-02-04 15:02:38', '2020-02-04 15:02:38'),\
(106, 3, '2020-02-04 15:03:09', '2020-02-04 15:03:09'),\
(107, 7, '2020-02-04 22:26:41', '2020-02-04 22:26:41'),\
(108, 7, '2020-02-04 22:33:56', '2020-02-04 22:33:56'),\
(109, 7, '2020-02-04 22:34:39', '2020-02-04 22:34:39'),\
(110, 7, '2020-02-04 22:37:59', '2020-02-04 22:37:59'),\
(111, 7, '2020-02-04 22:38:11', '2020-02-04 22:38:11'),\
(112, 7, '2020-02-04 22:58:01', '2020-02-04 22:58:01'),\
(113, 7, '2020-02-06 20:18:41', '2020-02-06 20:18:41'),\
(114, 7, '2020-02-07 03:22:54', '2020-02-07 03:22:54'),\
(115, 7, '2020-02-07 03:31:57', '2020-02-07 03:31:57'),\
(116, 7, '2020-02-07 05:17:08', '2020-02-07 05:17:08'),\
(117, 7, '2020-02-07 05:18:33', '2020-02-07 05:18:33'),\
(118, 7, '2020-02-07 05:19:22', '2020-02-07 05:19:22'),\
(119, 7, '2020-02-07 05:21:03', '2020-02-07 05:21:03'),\
(120, 7, '2020-02-07 05:22:09', '2020-02-07 05:22:09'),\
(121, 7, '2020-02-07 05:22:45', '2020-02-07 05:22:45'),\
(122, 7, '2020-02-07 05:27:35', '2020-02-07 05:27:35'),\
(123, 7, '2020-02-07 05:28:21', '2020-02-07 05:28:21'),\
(124, 7, '2020-02-07 05:30:47', '2020-02-07 05:30:47'),\
(125, 7, '2020-02-07 05:31:51', '2020-02-07 05:31:51'),\
(126, 7, '2020-02-07 05:32:46', '2020-02-07 05:32:46'),\
(127, 7, '2020-02-07 06:01:46', '2020-02-07 06:01:46'),\
(128, 7, '2020-02-07 06:06:08', '2020-02-07 06:06:08'),\
(129, 7, '2020-02-07 06:06:30', '2020-02-07 06:06:30'),\
(130, 7, '2020-02-07 06:08:03', '2020-02-07 06:08:03'),\
(131, 7, '2020-02-07 06:09:34', '2020-02-07 06:09:34'),\
(132, 7, '2020-02-07 06:10:27', '2020-02-07 06:10:27'),\
(133, 7, '2020-02-07 06:18:24', '2020-02-07 06:18:24'),\
(134, 7, '2020-02-07 06:20:00', '2020-02-07 06:20:00'),\
(135, 7, '2020-02-07 06:21:10', '2020-02-07 06:21:10'),\
(136, 7, '2020-02-07 06:23:05', '2020-02-07 06:23:05'),\
(137, 7, '2020-02-07 06:23:31', '2020-02-07 06:23:31'),\
(138, 7, '2020-02-07 06:25:57', '2020-02-07 06:25:57'),\
(139, 7, '2020-02-07 06:26:39', '2020-02-07 06:26:39'),\
(140, 7, '2020-02-07 06:28:22', '2020-02-07 06:28:22'),\
(141, 7, '2020-02-07 06:29:10', '2020-02-07 06:29:10'),\
(142, 7, '2020-02-07 06:31:42', '2020-02-07 06:31:42'),\
(143, 7, '2020-02-07 06:33:15', '2020-02-07 06:33:15'),\
(144, 7, '2020-02-07 06:33:45', '2020-02-07 06:33:45'),\
(145, 7, '2020-02-07 06:34:06', '2020-02-07 06:34:06'),\
(146, 7, '2020-02-07 06:36:14', '2020-02-07 06:36:14'),\
(147, 7, '2020-02-07 06:36:46', '2020-02-07 06:36:46'),\
(148, 7, '2020-02-07 06:41:42', '2020-02-07 06:41:42'),\
(149, 7, '2020-02-07 06:42:38', '2020-02-07 06:42:38'),\
(150, 7, '2020-02-07 06:44:00', '2020-02-07 06:44:00'),\
(151, 7, '2020-02-07 06:45:57', '2020-02-07 06:45:57'),\
(152, 7, '2020-02-07 06:46:42', '2020-02-07 06:46:42'),\
(153, 7, '2020-02-07 06:47:14', '2020-02-07 06:47:14'),\
(154, 7, '2020-02-07 06:47:38', '2020-02-07 06:47:38'),\
(155, 7, '2020-02-07 06:49:07', '2020-02-07 06:49:07'),\
(156, 7, '2020-02-07 06:49:27', '2020-02-07 06:49:27'),\
(157, 7, '2020-02-07 06:49:37', '2020-02-07 06:49:37'),\
(158, 7, '2020-02-07 06:50:08', '2020-02-07 06:50:08'),\
(159, 7, '2020-02-07 06:50:41', '2020-02-07 06:50:41'),\
(160, 7, '2020-02-07 06:51:49', '2020-02-07 06:51:49'),\
(161, 7, '2020-02-07 06:52:21', '2020-02-07 06:52:21'),\
(162, 7, '2020-02-07 06:53:54', '2020-02-07 06:53:54'),\
(163, 7, '2020-02-07 06:54:33', '2020-02-07 06:54:33'),\
(164, 7, '2020-02-07 06:56:07', '2020-02-07 06:56:07'),\
(165, 7, '2020-02-07 06:57:02', '2020-02-07 06:57:02'),\
(166, 7, '2020-02-07 06:59:28', '2020-02-07 06:59:28'),\
(167, 7, '2020-02-07 07:01:22', '2020-02-07 07:01:22'),\
(168, 7, '2020-02-07 07:02:32', '2020-02-07 07:02:32'),\
(169, 7, '2020-02-07 07:09:07', '2020-02-07 07:09:07'),\
(170, 7, '2020-02-08 01:30:34', '2020-02-08 01:30:34'),\
(171, 7, '2020-02-08 01:35:30', '2020-02-08 01:35:30'),\
(172, 7, '2020-02-08 02:17:39', '2020-02-08 02:17:39'),\
(173, 7, '2020-02-08 02:18:06', '2020-02-08 02:18:06'),\
(174, 7, '2020-02-08 02:19:33', '2020-02-08 02:19:33'),\
(175, 7, '2020-02-08 02:22:28', '2020-02-08 02:22:28'),\
(176, 7, '2020-02-08 02:49:02', '2020-02-08 02:49:02'),\
(177, 7, '2020-02-08 02:57:17', '2020-02-08 02:57:17'),\
(178, 7, '2020-02-08 02:59:24', '2020-02-08 02:59:24'),\
(179, 7, '2020-02-08 03:01:24', '2020-02-08 03:01:24'),\
(180, 7, '2020-02-08 03:04:38', '2020-02-08 03:04:38'),\
(181, 7, '2020-02-08 03:04:57', '2020-02-08 03:04:57'),\
(182, 7, '2020-02-08 03:06:21', '2020-02-08 03:06:21'),\
(183, 7, '2020-02-08 03:09:23', '2020-02-08 03:09:23'),\
(184, 7, '2020-02-08 03:09:50', '2020-02-08 03:09:50'),\
(185, 7, '2020-02-08 03:10:16', '2020-02-08 03:10:16'),\
(186, 7, '2020-02-08 03:10:32', '2020-02-08 03:10:32'),\
(187, 7, '2020-02-08 03:11:59', '2020-02-08 03:11:59'),\
(188, 7, '2020-02-08 03:12:23', '2020-02-08 03:12:23'),\
(189, 7, '2020-02-08 03:15:14', '2020-02-08 03:15:14'),\
(190, 7, '2020-02-08 03:16:37', '2020-02-08 03:16:37'),\
(191, 7, '2020-02-08 03:18:15', '2020-02-08 03:18:15'),\
(192, 7, '2020-02-08 03:22:09', '2020-02-08 03:22:09'),\
(193, 7, '2020-02-08 03:22:40', '2020-02-08 03:22:40'),\
(194, 7, '2020-02-08 03:23:13', '2020-02-08 03:23:13'),\
(195, 7, '2020-02-08 03:24:35', '2020-02-08 03:24:35'),\
(196, 7, '2020-02-08 03:25:00', '2020-02-08 03:25:00'),\
(197, 7, '2020-02-08 05:40:07', '2020-02-08 05:40:07'),\
(198, 7, '2020-02-08 05:52:33', '2020-02-08 05:52:33'),\
(199, 7, '2020-02-08 05:53:08', '2020-02-08 05:53:08'),\
(200, 7, '2020-02-08 05:56:59', '2020-02-08 05:56:59'),\
(201, 7, '2020-02-08 05:58:31', '2020-02-08 05:58:31'),\
(202, 7, '2020-02-08 06:00:05', '2020-02-08 06:00:05'),\
(203, 7, '2020-02-08 06:52:45', '2020-02-08 06:52:45'),\
(204, 7, '2020-02-08 06:54:02', '2020-02-08 06:54:02'),\
(205, 7, '2020-02-08 20:39:21', '2020-02-08 20:39:21'),\
(206, 7, '2020-02-08 20:42:14', '2020-02-08 20:42:14'),\
(207, 7, '2020-02-08 20:43:02', '2020-02-08 20:43:02'),\
(208, 7, '2020-02-08 20:49:53', '2020-02-08 20:49:53'),\
(209, 7, '2020-02-08 20:52:15', '2020-02-08 20:52:15'),\
(210, 7, '2020-02-08 21:03:38', '2020-02-08 21:03:38'),\
(211, 7, '2020-02-08 21:07:25', '2020-02-08 21:07:25'),\
(212, 7, '2020-02-08 21:58:52', '2020-02-08 21:58:52'),\
(213, 7, '2020-02-08 22:00:47', '2020-02-08 22:00:47'),\
(214, 7, '2020-02-08 22:36:23', '2020-02-08 22:36:23'),\
(215, 7, '2020-02-08 23:15:45', '2020-02-08 23:15:45'),\
(216, 7, '2020-02-08 23:17:27', '2020-02-08 23:17:27'),\
(217, 7, '2020-02-08 23:19:11', '2020-02-08 23:19:11'),\
(218, 7, '2020-02-08 23:21:15', '2020-02-08 23:21:15'),\
(219, 7, '2020-02-08 23:24:34', '2020-02-08 23:24:34'),\
(220, 7, '2020-02-08 23:32:42', '2020-02-08 23:32:42'),\
(221, 7, '2020-02-09 00:42:12', '2020-02-09 00:42:12'),\
(222, 7, '2020-02-09 00:43:28', '2020-02-09 00:43:28'),\
(223, 7, '2020-02-09 00:54:52', '2020-02-09 00:54:52'),\
(224, 7, '2020-02-09 00:55:32', '2020-02-09 00:55:32'),\
(225, 7, '2020-02-09 00:56:47', '2020-02-09 00:56:47'),\
(226, 7, '2020-02-09 01:08:43', '2020-02-09 01:08:43'),\
(227, 7, '2020-02-09 01:09:29', '2020-02-09 01:09:29'),\
(228, 7, '2020-02-09 01:10:39', '2020-02-09 01:10:39'),\
(229, 7, '2020-02-09 01:11:33', '2020-02-09 01:11:33'),\
(230, 7, '2020-02-09 01:14:36', '2020-02-09 01:14:36'),\
(231, 7, '2020-02-09 01:15:10', '2020-02-09 01:15:10'),\
(232, 7, '2020-02-09 01:15:29', '2020-02-09 01:15:29'),\
(233, 7, '2020-02-09 01:29:04', '2020-02-09 01:29:04'),\
(234, 7, '2020-02-09 01:38:50', '2020-02-09 01:38:50'),\
(235, 7, '2020-02-09 02:06:51', '2020-02-09 02:06:51'),\
(236, 7, '2020-02-09 02:12:04', '2020-02-09 02:12:04'),\
(237, 7, '2020-02-09 02:12:36', '2020-02-09 02:12:36'),\
(238, 7, '2020-02-09 02:17:26', '2020-02-09 02:17:26'),\
(239, 7, '2020-02-09 02:21:56', '2020-02-09 02:21:56'),\
(240, 7, '2020-02-09 02:24:25', '2020-02-09 02:24:25'),\
(241, 7, '2020-02-09 02:25:19', '2020-02-09 02:25:19'),\
(242, 7, '2020-02-10 13:23:32', '2020-02-10 13:23:32'),\
(243, 3, '2020-02-11 19:22:51', '2020-02-11 19:22:51'),\
(244, 3, '2020-02-11 19:26:30', '2020-02-11 19:26:30'),\
(245, 3, '2020-02-11 19:27:30', '2020-02-11 19:27:30'),\
(246, 3, '2020-02-11 19:28:35', '2020-02-11 19:28:35'),\
(247, 3, '2020-02-11 19:33:00', '2020-02-11 19:33:00'),\
(248, 3, '2020-02-11 19:33:03', '2020-02-11 19:33:03'),\
(249, 3, '2020-02-11 19:33:42', '2020-02-11 19:33:42'),\
(250, 3, '2020-02-11 19:36:15', '2020-02-11 19:36:15'),\
(251, 3, '2020-02-11 19:45:42', '2020-02-11 19:45:42'),\
(252, 3, '2020-02-11 19:48:01', '2020-02-11 19:48:01'),\
(253, 3, '2020-02-11 19:49:29', '2020-02-11 19:49:29'),\
(254, 3, '2020-02-11 19:50:52', '2020-02-11 19:50:52'),\
(255, 3, '2020-02-11 19:51:20', '2020-02-11 19:51:20'),\
(256, 3, '2020-02-11 19:51:48', '2020-02-11 19:51:48'),\
(257, 3, '2020-02-11 19:52:33', '2020-02-11 19:52:33'),\
(258, 3, '2020-02-11 19:52:47', '2020-02-11 19:52:47'),\
(259, 3, '2020-02-11 19:53:41', '2020-02-11 19:53:41'),\
(260, 3, '2020-02-11 19:57:12', '2020-02-11 19:57:12'),\
(261, 3, '2020-02-11 19:58:09', '2020-02-11 19:58:09'),\
(262, 3, '2020-02-11 19:58:25', '2020-02-11 19:58:25');\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_agent`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_agent` (\
`company_id` int(10) unsigned\
,`name` varchar(191)\
,`description` text\
,`website` varchar(191)\
,`city_id` int(10) unsigned\
,`agent_id` int(10) unsigned\
,`latitude` varchar(191)\
,`longitude` varchar(191)\
,`phone` varchar(191)\
,`email` varchar(191)\
,`membership_name` varchar(191)\
,`membership_id` int(10) unsigned\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_leased_properties`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_leased_properties` (\
`day` int(1)\
,`quantity` bigint(21)\
,`date` timestamp\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_newsletter_for_months`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_newsletter_for_months` (\
`month_nl` int(2)\
,`quantity_nl` bigint(21)\
,`date_nl` timestamp\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_properties`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_properties` (\
`property_id` int(10) unsigned\
,`name` varchar(191)\
,`description` text\
,`meters` varchar(191)\
,`bedrooms` int(11)\
,`bathrooms` int(11)\
,`rent` int(11)\
,`verified` tinyint(1)\
,`available` tinyint(1)\
,`available_date` date\
,`pet_preference` varchar(5)\
,`private_parking` int(11)\
,`public_parking` tinyint(1)\
,`furnished` tinyint(1)\
,`city_id` int(10) unsigned\
,`commune_id` int(10) unsigned\
,`property_type_id` int(10) unsigned\
,`type_stay` enum('SHORT_STAY','LONG_STAY')\
,`path` text\
,`property_type_name` varchar(191)\
,`owner_id` int(10) unsigned\
,`membership_name` varchar(191)\
,`membership_id` int(10) unsigned\
,`property_for_id` int(10) unsigned\
,`demand` int(11)\
,`expire` date\
,`type_user` tinyint(4)\
,`company_id` int(10) unsigned\
,`latitude` varchar(191)\
,`longitude` varchar(191)\
,`is_project` tinyint(1)\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_properties_descriptor_days`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_properties_descriptor_days` (\
`day` int(1)\
,`quantity` bigint(21)\
,`date` timestamp\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_properties_wu`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_properties_wu` (\
`property_id` int(10) unsigned\
,`name` varchar(191)\
,`description` text\
,`meters` varchar(191)\
,`bedrooms` int(11)\
,`bathrooms` int(11)\
,`rent` int(11)\
,`verified` tinyint(1)\
,`available` tinyint(1)\
,`available_date` date\
,`pet_preference` varchar(5)\
,`private_parking` int(11)\
,`public_parking` tinyint(1)\
,`furnished` tinyint(1)\
,`city_id` int(10) unsigned\
,`commune_id` int(10) unsigned\
,`property_type_id` int(10) unsigned\
,`path` text\
,`property_type_name` varchar(191)\
,`owner_id` int(10) unsigned\
,`membership_name` varchar(191)\
,`membership_id` int(10) unsigned\
,`demand` int(11)\
,`property_for_id` int(10) unsigned\
,`type_stay` enum('SHORT_STAY','LONG_STAY')\
,`user_id` int(10) unsigned\
,`expire` date\
,`type_user` tinyint(4)\
,`company_id` int(10) unsigned\
,`latitude` varchar(191)\
,`longitude` varchar(191)\
,`is_project` tinyint(1)\
,`score` int(11)\
,`favorite` tinyint(1)\
,`applied` tinyint(1)\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_roles_memberships_users`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_roles_memberships_users` (\
`id` int(10) unsigned\
,`role_id` int(10) unsigned\
,`name` varchar(191)\
,`u_count` bigint(21)\
,`enabled` tinyint(1)\
,`role_name` varchar(191)\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_scoring`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_scoring` (\
`scoring_id` int(10) unsigned\
,`scoring_name` varchar(191)\
,`scoring_des` varchar(191)\
,`cat_id` int(10) unsigned\
,`cat_name` varchar(191)\
,`cat_des` varchar(191)\
,`cat_feed` varchar(191)\
,`det_id` int(10) unsigned\
,`det_name` varchar(191)\
,`det_des` varchar(191)\
,`det_feed` varchar(191)\
,`points` int(11)\
,`method` tinyint(1)\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_scoring_category_points`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_scoring_category_points` (\
`id` int(10) unsigned\
,`name` varchar(191)\
,`feed_back` varchar(191)\
,`description` varchar(191)\
,`scoring_id` int(10) unsigned\
,`points_scoring` decimal(32,0)\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_scoring_points`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_scoring_points` (\
`id` int(10) unsigned\
,`name` varchar(191)\
,`description` varchar(191)\
,`points_scoring` decimal(32,0)\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_services`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_services` (\
`id` int(10) unsigned\
,`company_id` int(10) unsigned\
,`user_id` int(10) unsigned\
,`description` text\
,`name` varchar(191)\
,`email` varchar(191)\
,`phone` varchar(191)\
,`cell_phone` varchar(191)\
,`city_id` int(10) unsigned\
,`address` varchar(191)\
,`membership_name` varchar(191)\
,`membership_id` int(10) unsigned\
,`path` text\
,`service` varchar(191)\
,`service_id` int(10) unsigned\
,`service_type_id` int(10) unsigned\
,`service_type_name` varchar(191)\
,`service_description` text\
,`user_firstname` varchar(191)\
,`user_lastname` varchar(191)\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_users_count_role`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_users_count_role` (\
`role_id` int(10) unsigned\
,`u_count` bigint(21)\
);\
\
-- --------------------------------------------------------\
\
--\
-- Stand-in structure for view `v_users_membership_count`\
-- (See below for the actual view)\
--\
CREATE TABLE `v_users_membership_count` (\
`id` int(10) unsigned\
,`name` varchar(191)\
,`u_count` bigint(21)\
,`role_id` int(10) unsigned\
);\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_agent`\
--\
DROP TABLE IF EXISTS `v_agent`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_agent`  AS  select distinct `c`.`id` AS `company_id`,`c`.`name` AS `name`,`c`.`description` AS `description`,`c`.`website` AS `website`,`c`.`city_id` AS `city_id`,`c`.`user_id` AS `agent_id`,`c`.`latitude` AS `latitude`,`c`.`longitude` AS `longitude`,`u`.`phone` AS `phone`,`u`.`email` AS `email`,`m`.`name` AS `membership_name`,`m`.`id` AS `membership_id` from ((((`companies` `c` join `users` `u` on((`c`.`user_id` = `u`.`id`))) join `users_has_memberships` `h` on((`u`.`id` = `h`.`user_id`))) join `memberships` `m` on((`m`.`id` = `h`.`membership_id`))) join `roles` `r` on((`r`.`id` = `m`.`role_id`))) where ((`c`.`type` = 0) and (`r`.`id` = 3)) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_leased_properties`\
--\
DROP TABLE IF EXISTS `v_leased_properties`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_leased_properties`  AS  (select dayofweek(`properties`.`created_at`) AS `day`,count(`properties`.`id`) AS `quantity`,`properties`.`created_at` AS `date` from `properties` group by `properties`.`created_at` order by `day`) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_newsletter_for_months`\
--\
DROP TABLE IF EXISTS `v_newsletter_for_months`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_newsletter_for_months`  AS  (select month(`newsletters`.`created_at`) AS `month_nl`,count(`newsletters`.`id`) AS `quantity_nl`,`newsletters`.`created_at` AS `date_nl` from `newsletters` group by `date_nl` order by `month_nl`) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_properties`\
--\
DROP TABLE IF EXISTS `v_properties`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_properties`  AS  select distinct `a`.`id` AS `property_id`,`a`.`name` AS `name`,`a`.`description` AS `description`,`a`.`meters` AS `meters`,`a`.`bedrooms` AS `bedrooms`,`a`.`bathrooms` AS `bathrooms`,`a`.`rent` AS `rent`,`a`.`verified` AS `verified`,`a`.`available` AS `available`,`a`.`available_date` AS `available_date`,`a`.`pet_preference` AS `pet_preference`,`a`.`private_parking` AS `private_parking`,`a`.`public_parking` AS `public_parking`,`a`.`furnished` AS `furnished`,`a`.`city_id` AS `city_id`,`a`.`commune_id` AS `commune_id`,`a`.`property_type_id` AS `property_type_id`,`a`.`type_stay` AS `type_stay`,`d`.`path` AS `path`,`b`.`name` AS `property_type_name`,`c`.`user_id` AS `owner_id`,`f`.`name` AS `membership_name`,`f`.`id` AS `membership_id`,`o`.`property_for_id` AS `property_for_id`,`SF_DEMAND`(`a`.`id`) AS `demand`,`a`.`expire_at` AS `expire`,`c`.`type` AS `type_user`,`a`.`company_id` AS `company_id`,`a`.`latitude` AS `latitude`,`a`.`longitude` AS `longitude`,`a`.`is_project` AS `is_project` from (((((((`properties` `a` join `properties_types` `b`) join `users_has_properties` `c`) join `photos` `d`) join `users_has_memberships` `e`) join `memberships` `f`) join `roles` `g`) join `properties_has_properties_for` `o`) where (`a`.`active` and (`b`.`id` = `a`.`property_type_id`) and (`a`.`id` = `c`.`property_id`) and ((`c`.`type` = 1) or (`c`.`type` = 5)) and (`a`.`id` = `d`.`property_id`) and (`d`.`cover` = 1) and (`e`.`user_id` = `c`.`user_id`) and (`e`.`membership_id` = `f`.`id`) and ((`f`.`role_id` = 2) or (`f`.`role_id` = 3)) and `f`.`enabled` and (`o`.`property_id` = `a`.`id`) and isnull(`a`.`deleted_at`) and ((`a`.`expire_at` >= curdate()) or isnull(`a`.`expire_at`)) and (((`f`.`role_id` = 2) and (`c`.`type` = 1)) or ((`f`.`role_id` = 3) and (`c`.`type` = 5)))) order by `property_id` ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_properties_descriptor_days`\
--\
DROP TABLE IF EXISTS `v_properties_descriptor_days`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_properties_descriptor_days`  AS  (select dayofweek(`properties`.`created_at`) AS `day`,count(`properties`.`id`) AS `quantity`,`properties`.`created_at` AS `date` from `properties` group by `properties`.`created_at` order by `day`) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_properties_wu`\
--\
DROP TABLE IF EXISTS `v_properties_wu`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_properties_wu`  AS  select `p`.`property_id` AS `property_id`,`p`.`name` AS `name`,`p`.`description` AS `description`,`p`.`meters` AS `meters`,`p`.`bedrooms` AS `bedrooms`,`p`.`bathrooms` AS `bathrooms`,`p`.`rent` AS `rent`,`p`.`verified` AS `verified`,`p`.`available` AS `available`,`p`.`available_date` AS `available_date`,`p`.`pet_preference` AS `pet_preference`,`p`.`private_parking` AS `private_parking`,`p`.`public_parking` AS `public_parking`,`p`.`furnished` AS `furnished`,`p`.`city_id` AS `city_id`,`p`.`commune_id` AS `commune_id`,`p`.`property_type_id` AS `property_type_id`,`p`.`path` AS `path`,`p`.`property_type_name` AS `property_type_name`,`p`.`owner_id` AS `owner_id`,`p`.`membership_name` AS `membership_name`,`p`.`membership_id` AS `membership_id`,`p`.`demand` AS `demand`,`p`.`property_for_id` AS `property_for_id`,`p`.`type_stay` AS `type_stay`,`u`.`id` AS `user_id`,`p`.`expire` AS `expire`,`p`.`type_user` AS `type_user`,`p`.`company_id` AS `company_id`,`p`.`latitude` AS `latitude`,`p`.`longitude` AS `longitude`,`p`.`is_project` AS `is_project`,`SF_SCORE`(`u`.`id`,`p`.`property_id`) AS `score`,`SF_FAVORITE`(`u`.`id`,`p`.`property_id`) AS `favorite`,`SF_APPLIED`(`u`.`id`,`p`.`property_id`) AS `applied` from (`users` `u` join `v_properties` `p`) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_roles_memberships_users`\
--\
DROP TABLE IF EXISTS `v_roles_memberships_users`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_roles_memberships_users`  AS  (select `memberships`.`id` AS `id`,`memberships`.`role_id` AS `role_id`,`memberships`.`name` AS `name`,count(`users_has_memberships`.`membership_id`) AS `u_count`,`memberships`.`enabled` AS `enabled`,`roles`.`name` AS `role_name` from ((`memberships` left join `users_has_memberships` on((`memberships`.`id` = `users_has_memberships`.`membership_id`))) join `roles` on((`roles`.`id` = `memberships`.`role_id`))) group by `memberships`.`id`) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_scoring`\
--\
DROP TABLE IF EXISTS `v_scoring`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_scoring`  AS  (select `s`.`id` AS `scoring_id`,`s`.`name` AS `scoring_name`,`s`.`description` AS `scoring_des`,`c`.`id` AS `cat_id`,`c`.`name` AS `cat_name`,`c`.`description` AS `cat_des`,`c`.`feed_back` AS `cat_feed`,`d`.`id` AS `det_id`,`d`.`name` AS `det_name`,`d`.`description` AS `det_des`,`d`.`feed_back` AS `det_feed`,`d`.`points` AS `points`,`d`.`method` AS `method` from ((`scoring` `s` join `cat_scoring` `c` on((`s`.`id` = `c`.`scoring_id`))) join `det_scoring` `d` on((`c`.`id` = `d`.`cat_scoring_id`)))) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_scoring_category_points`\
--\
DROP TABLE IF EXISTS `v_scoring_category_points`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_scoring_category_points`  AS  (select `c`.`id` AS `id`,`c`.`name` AS `name`,`c`.`feed_back` AS `feed_back`,`c`.`description` AS `description`,`c`.`scoring_id` AS `scoring_id`,sum(`d`.`points`) AS `points_scoring` from (`cat_scoring` `c` left join `det_scoring` `d` on((`d`.`cat_scoring_id` = `c`.`id`))) group by `c`.`id`) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_scoring_points`\
--\
DROP TABLE IF EXISTS `v_scoring_points`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_scoring_points`  AS  (select `s`.`id` AS `id`,`s`.`name` AS `name`,`s`.`description` AS `description`,sum(`d`.`points`) AS `points_scoring` from ((`scoring` `s` left join `cat_scoring` `c` on((`c`.`scoring_id` = `s`.`id`))) left join `det_scoring` `d` on((`d`.`cat_scoring_id` = `c`.`id`))) group by `s`.`id`,`s`.`name`) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_services`\
--\
DROP TABLE IF EXISTS `v_services`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_services`  AS  select distinct `cs`.`id` AS `id`,`c`.`id` AS `company_id`,`c`.`user_id` AS `user_id`,`c`.`description` AS `description`,`c`.`name` AS `name`,`c`.`email` AS `email`,`c`.`phone` AS `phone`,`c`.`cell_phone` AS `cell_phone`,`u`.`city_id` AS `city_id`,`u`.`address` AS `address`,`m`.`name` AS `membership_name`,`m`.`id` AS `membership_id`,`p`.`path` AS `path`,`s`.`name` AS `service`,`s`.`id` AS `service_id`,`t`.`id` AS `service_type_id`,`t`.`name` AS `service_type_name`,`cs`.`description` AS `service_description`,`u`.`firstname` AS `user_firstname`,`u`.`lastname` AS `user_lastname` from ((((((((`companies` `c` join `users` `u`) join `roles` `r`) join `memberships` `m`) join `users_has_memberships` `h`) join `photos` `p`) join `companies_has_services_list` `cs`) join `services_list` `s`) join `services_type` `t`) where ((`u`.`id` = `c`.`user_id`) and (`u`.`id` = `h`.`user_id`) and (`h`.`membership_id` = `m`.`id`) and (`m`.`role_id` = `r`.`id`) and (`r`.`id` = 4) and (`c`.`id` = `p`.`company_id`) and (`p`.`logo` = 1) and (`cs`.`company_id` = `c`.`id`) and (`s`.`id` = `cs`.`service_list_id`) and (`s`.`service_type_id` = `t`.`id`)) order by `s`.`name` ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_users_count_role`\
--\
DROP TABLE IF EXISTS `v_users_count_role`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_users_count_role`  AS  (select `r`.`id` AS `role_id`,count(`uhm`.`id`) AS `u_count` from ((`memberships` `m` left join `users_has_memberships` `uhm` on((`m`.`id` = `uhm`.`membership_id`))) join `roles` `r` on((`r`.`id` = `m`.`role_id`))) group by `r`.`id`) ;\
\
-- --------------------------------------------------------\
\
--\
-- Structure for view `v_users_membership_count`\
--\
DROP TABLE IF EXISTS `v_users_membership_count`;\
\
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `v_users_membership_count`  AS  (select `memberships`.`id` AS `id`,`memberships`.`name` AS `name`,count(`users_has_memberships`.`membership_id`) AS `u_count`,`memberships`.`role_id` AS `role_id` from (`memberships` left join `users_has_memberships` on((`users_has_memberships`.`membership_id` = `memberships`.`id`))) group by `memberships`.`id`) ;\
\
--\
-- Indexes for dumped tables\
--\
\
--\
-- Indexes for table `amenities`\
--\
ALTER TABLE `amenities`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `banks`\
--\
ALTER TABLE `banks`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `cat_scoring`\
--\
ALTER TABLE `cat_scoring`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `cat_scoring_scoring_id_foreign` (`scoring_id`);\
\
--\
-- Indexes for table `cities`\
--\
ALTER TABLE `cities`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `cities_region_id_foreign` (`region_id`);\
\
--\
-- Indexes for table `civil_status`\
--\
ALTER TABLE `civil_status`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `communes`\
--\
ALTER TABLE `communes`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `communes_city_id_foreign` (`city_id`);\
\
--\
-- Indexes for table `companies`\
--\
ALTER TABLE `companies`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `companies_user_id_foreign` (`user_id`),\
  ADD KEY `companies_city_id_foreign` (`city_id`);\
\
--\
-- Indexes for table `companies_has_services_list`\
--\
ALTER TABLE `companies_has_services_list`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `companies_has_services_list_company_id_foreign` (`company_id`),\
  ADD KEY `companies_has_services_list_service_list_id_foreign` (`service_list_id`);\
\
--\
-- Indexes for table `configurations`\
--\
ALTER TABLE `configurations`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `contact_messages`\
--\
ALTER TABLE `contact_messages`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `contracts`\
--\
ALTER TABLE `contracts`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `contracts_property_id_foreign` (`property_id`);\
\
--\
-- Indexes for table `conversations`\
--\
ALTER TABLE `conversations`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `conversations_user_id_foreign` (`user_id`),\
  ADD KEY `conversations_contact_id_foreign` (`contact_id`);\
\
--\
-- Indexes for table `countries`\
--\
ALTER TABLE `countries`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `coupons`\
--\
ALTER TABLE `coupons`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `coupons_membership_id_foreign` (`membership_id`);\
\
--\
-- Indexes for table `det_scoring`\
--\
ALTER TABLE `det_scoring`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `det_scoring_cat_scoring_id_foreign` (`cat_scoring_id`);\
\
--\
-- Indexes for table `files`\
--\
ALTER TABLE `files`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `files_user_id_foreign` (`user_id`),\
  ADD KEY `files_property_id_foreign` (`property_id`),\
  ADD KEY `files_company_id_foreign` (`company_id`);\
\
--\
-- Indexes for table `memberships`\
--\
ALTER TABLE `memberships`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `memberships_role_id_foreign` (`role_id`);\
\
--\
-- Indexes for table `messages`\
--\
ALTER TABLE `messages`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `messages_from_id_foreign` (`from_id`),\
  ADD KEY `messages_to_id_foreign` (`to_id`);\
\
--\
-- Indexes for table `migrations`\
--\
ALTER TABLE `migrations`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `newsletters`\
--\
ALTER TABLE `newsletters`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `newsletters_commune_id_foreign` (`commune_id`);\
\
--\
-- Indexes for table `notifications`\
--\
ALTER TABLE `notifications`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `password_resets`\
--\
ALTER TABLE `password_resets`\
  ADD KEY `password_resets_email_index` (`email`);\
\
--\
-- Indexes for table `payments`\
--\
ALTER TABLE `payments`\
  ADD PRIMARY KEY (`id`),\
  ADD UNIQUE KEY `payments_order_unique` (`order`),\
  ADD UNIQUE KEY `payments_contract_id_unique` (`contract_id`),\
  ADD KEY `payments_user_id_foreign` (`user_id`),\
  ADD KEY `payments_property_id_foreign` (`property_id`);\
\
--\
-- Indexes for table `photos`\
--\
ALTER TABLE `photos`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `photos_user_id_foreign` (`user_id`),\
  ADD KEY `photos_property_id_foreign` (`property_id`),\
  ADD KEY `photos_company_id_foreign` (`company_id`),\
  ADD KEY `photos_service_list_id_foreign` (`service_list_id`),\
  ADD KEY `photos_space_id_foreign` (`space_id`);\
\
--\
-- Indexes for table `postulates`\
--\
ALTER TABLE `postulates`\
  ADD KEY `postulates_id_foreign` (`id`);\
\
--\
-- Indexes for table `privacies`\
--\
ALTER TABLE `privacies`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `properties`\
--\
ALTER TABLE `properties`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `properties_commune_id_foreign` (`commune_id`),\
  ADD KEY `properties_property_type_id_foreign` (`property_type_id`),\
  ADD KEY `properties_city_id_foreign` (`city_id`),\
  ADD KEY `properties_company_id_foreign` (`company_id`),\
  ADD KEY `properties_executive_id_foreign` (`executive_id`);\
\
--\
-- Indexes for table `properties_for`\
--\
ALTER TABLE `properties_for`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `properties_has_amenities`\
--\
ALTER TABLE `properties_has_amenities`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `properties_has_amenities_amenity_id_foreign` (`amenity_id`),\
  ADD KEY `properties_has_amenities_property_id_foreign` (`property_id`);\
\
--\
-- Indexes for table `properties_has_properties_for`\
--\
ALTER TABLE `properties_has_properties_for`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `properties_has_properties_for_property_id_foreign` (`property_id`),\
  ADD KEY `properties_has_properties_for_property_for_id_foreign` (`property_for_id`);\
\
--\
-- Indexes for table `properties_types`\
--\
ALTER TABLE `properties_types`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `providers`\
--\
ALTER TABLE `providers`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `regions`\
--\
ALTER TABLE `regions`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `regions_country_id_foreign` (`country_id`);\
\
--\
-- Indexes for table `roles`\
--\
ALTER TABLE `roles`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `sasapplicants`\
--\
ALTER TABLE `sasapplicants`\
  ADD PRIMARY KEY (`id`),\
  ADD UNIQUE KEY `sasapplicants_tokensas_unique` (`tokenSas`),\
  ADD UNIQUE KEY `sasapplicants_applicant_id_unique` (`applicant_id`),\
  ADD KEY `sasapplicants_user_id_foreign` (`user_id`);\
\
--\
-- Indexes for table `schedules`\
--\
ALTER TABLE `schedules`\
  ADD KEY `schedules_id_foreign` (`id`);\
\
--\
-- Indexes for table `scoring`\
--\
ALTER TABLE `scoring`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `services_list`\
--\
ALTER TABLE `services_list`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `services_list_service_type_id_foreign` (`service_type_id`);\
\
--\
-- Indexes for table `services_type`\
--\
ALTER TABLE `services_type`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `spaces`\
--\
ALTER TABLE `spaces`\
  ADD PRIMARY KEY (`id`);\
\
--\
-- Indexes for table `useradmins`\
--\
ALTER TABLE `useradmins`\
  ADD PRIMARY KEY (`id`),\
  ADD UNIQUE KEY `useradmins_email_unique` (`email`);\
\
--\
-- Indexes for table `users`\
--\
ALTER TABLE `users`\
  ADD PRIMARY KEY (`id`),\
  ADD UNIQUE KEY `users_email_unique` (`email`),\
  ADD UNIQUE KEY `users_phone_unique` (`phone`),\
  ADD UNIQUE KEY `users_api_token_unique` (`api_token`),\
  ADD KEY `users_country_id_foreign` (`country_id`),\
  ADD KEY `users_civil_status_id_foreign` (`civil_status_id`),\
  ADD KEY `users_collateral_id_foreign` (`collateral_id`),\
  ADD KEY `users_city_id_foreign` (`city_id`),\
  ADD KEY `users_bank_id_foreign` (`bank_id`);\
\
--\
-- Indexes for table `users_has_amenities`\
--\
ALTER TABLE `users_has_amenities`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `users_has_amenities_amenity_id_foreign` (`amenity_id`),\
  ADD KEY `users_has_amenities_user_id_foreign` (`user_id`);\
\
--\
-- Indexes for table `users_has_contracts`\
--\
ALTER TABLE `users_has_contracts`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `users_has_contracts_user_id_foreign` (`user_id`),\
  ADD KEY `users_has_contracts_contract_id_foreign` (`contract_id`);\
\
--\
-- Indexes for table `users_has_coupons`\
--\
ALTER TABLE `users_has_coupons`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `users_has_coupons_user_id_foreign` (`user_id`),\
  ADD KEY `users_has_coupons_coupon_id_foreign` (`coupon_id`);\
\
--\
-- Indexes for table `users_has_memberships`\
--\
ALTER TABLE `users_has_memberships`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `users_has_memberships_membership_id_foreign` (`membership_id`),\
  ADD KEY `users_has_memberships_user_id_foreign` (`user_id`);\
\
--\
-- Indexes for table `users_has_notifications`\
--\
ALTER TABLE `users_has_notifications`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `users_has_notifications_notification_id_foreign` (`notification_id`),\
  ADD KEY `users_has_notifications_user_id_foreign` (`user_id`);\
\
--\
-- Indexes for table `users_has_privacies`\
--\
ALTER TABLE `users_has_privacies`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `users_has_privacies_privacy_id_foreign` (`privacy_id`),\
  ADD KEY `users_has_privacies_user_id_foreign` (`user_id`);\
\
--\
-- Indexes for table `users_has_properties`\
--\
ALTER TABLE `users_has_properties`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `users_has_properties_property_id_foreign` (`property_id`),\
  ADD KEY `users_has_properties_user_id_foreign` (`user_id`);\
\
--\
-- Indexes for table `user_provider`\
--\
ALTER TABLE `user_provider`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `user_provider_user_id_foreign` (`user_id`),\
  ADD KEY `user_provider_provider_id_foreign` (`provider_id`);\
\
--\
-- Indexes for table `visits`\
--\
ALTER TABLE `visits`\
  ADD PRIMARY KEY (`id`),\
  ADD KEY `visits_property_id_foreign` (`property_id`);\
\
--\
-- AUTO_INCREMENT for dumped tables\
--\
\
--\
-- AUTO_INCREMENT for table `amenities`\
--\
ALTER TABLE `amenities`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;\
\
--\
-- AUTO_INCREMENT for table `banks`\
--\
ALTER TABLE `banks`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;\
\
--\
-- AUTO_INCREMENT for table `cat_scoring`\
--\
ALTER TABLE `cat_scoring`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;\
\
--\
-- AUTO_INCREMENT for table `cities`\
--\
ALTER TABLE `cities`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6321;\
\
--\
-- AUTO_INCREMENT for table `civil_status`\
--\
ALTER TABLE `civil_status`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;\
\
--\
-- AUTO_INCREMENT for table `communes`\
--\
ALTER TABLE `communes`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=346;\
\
--\
-- AUTO_INCREMENT for table `companies`\
--\
ALTER TABLE `companies`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;\
\
--\
-- AUTO_INCREMENT for table `companies_has_services_list`\
--\
ALTER TABLE `companies_has_services_list`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;\
\
--\
-- AUTO_INCREMENT for table `configurations`\
--\
ALTER TABLE `configurations`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;\
\
--\
-- AUTO_INCREMENT for table `contact_messages`\
--\
ALTER TABLE `contact_messages`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;\
\
--\
-- AUTO_INCREMENT for table `contracts`\
--\
ALTER TABLE `contracts`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;\
\
--\
-- AUTO_INCREMENT for table `conversations`\
--\
ALTER TABLE `conversations`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;\
\
--\
-- AUTO_INCREMENT for table `countries`\
--\
ALTER TABLE `countries`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=202;\
\
--\
-- AUTO_INCREMENT for table `coupons`\
--\
ALTER TABLE `coupons`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;\
\
--\
-- AUTO_INCREMENT for table `det_scoring`\
--\
ALTER TABLE `det_scoring`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;\
\
--\
-- AUTO_INCREMENT for table `files`\
--\
ALTER TABLE `files`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=116;\
\
--\
-- AUTO_INCREMENT for table `memberships`\
--\
ALTER TABLE `memberships`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;\
\
--\
-- AUTO_INCREMENT for table `messages`\
--\
ALTER TABLE `messages`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;\
\
--\
-- AUTO_INCREMENT for table `migrations`\
--\
ALTER TABLE `migrations`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;\
\
--\
-- AUTO_INCREMENT for table `newsletters`\
--\
ALTER TABLE `newsletters`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;\
\
--\
-- AUTO_INCREMENT for table `notifications`\
--\
ALTER TABLE `notifications`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;\
\
--\
-- AUTO_INCREMENT for table `payments`\
--\
ALTER TABLE `payments`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;\
\
--\
-- AUTO_INCREMENT for table `photos`\
--\
ALTER TABLE `photos`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;\
\
--\
-- AUTO_INCREMENT for table `privacies`\
--\
ALTER TABLE `privacies`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;\
\
--\
-- AUTO_INCREMENT for table `properties`\
--\
ALTER TABLE `properties`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;\
\
--\
-- AUTO_INCREMENT for table `properties_for`\
--\
ALTER TABLE `properties_for`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;\
\
--\
-- AUTO_INCREMENT for table `properties_has_amenities`\
--\
ALTER TABLE `properties_has_amenities`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;\
\
--\
-- AUTO_INCREMENT for table `properties_has_properties_for`\
--\
ALTER TABLE `properties_has_properties_for`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;\
\
--\
-- AUTO_INCREMENT for table `properties_types`\
--\
ALTER TABLE `properties_types`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;\
\
--\
-- AUTO_INCREMENT for table `providers`\
--\
ALTER TABLE `providers`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;\
\
--\
-- AUTO_INCREMENT for table `regions`\
--\
ALTER TABLE `regions`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=128;\
\
--\
-- AUTO_INCREMENT for table `roles`\
--\
ALTER TABLE `roles`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;\
\
--\
-- AUTO_INCREMENT for table `sasapplicants`\
--\
ALTER TABLE `sasapplicants`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;\
\
--\
-- AUTO_INCREMENT for table `scoring`\
--\
ALTER TABLE `scoring`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;\
\
--\
-- AUTO_INCREMENT for table `services_list`\
--\
ALTER TABLE `services_list`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;\
\
--\
-- AUTO_INCREMENT for table `services_type`\
--\
ALTER TABLE `services_type`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;\
\
--\
-- AUTO_INCREMENT for table `spaces`\
--\
ALTER TABLE `spaces`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;\
\
--\
-- AUTO_INCREMENT for table `useradmins`\
--\
ALTER TABLE `useradmins`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;\
\
--\
-- AUTO_INCREMENT for table `users`\
--\
ALTER TABLE `users`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;\
\
--\
-- AUTO_INCREMENT for table `users_has_amenities`\
--\
ALTER TABLE `users_has_amenities`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;\
\
--\
-- AUTO_INCREMENT for table `users_has_contracts`\
--\
ALTER TABLE `users_has_contracts`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;\
\
--\
-- AUTO_INCREMENT for table `users_has_coupons`\
--\
ALTER TABLE `users_has_coupons`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;\
\
--\
-- AUTO_INCREMENT for table `users_has_memberships`\
--\
ALTER TABLE `users_has_memberships`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;\
\
--\
-- AUTO_INCREMENT for table `users_has_notifications`\
--\
ALTER TABLE `users_has_notifications`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;\
\
--\
-- AUTO_INCREMENT for table `users_has_privacies`\
--\
ALTER TABLE `users_has_privacies`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;\
\
--\
-- AUTO_INCREMENT for table `users_has_properties`\
--\
ALTER TABLE `users_has_properties`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;\
\
--\
-- AUTO_INCREMENT for table `user_provider`\
--\
ALTER TABLE `user_provider`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;\
\
--\
-- AUTO_INCREMENT for table `visits`\
--\
ALTER TABLE `visits`\
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=263;\
\
--\
-- Constraints for dumped tables\
--\
\
--\
-- Constraints for table `cat_scoring`\
--\
ALTER TABLE `cat_scoring`\
  ADD CONSTRAINT `cat_scoring_scoring_id_foreign` FOREIGN KEY (`scoring_id`) REFERENCES `scoring` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `cities`\
--\
ALTER TABLE `cities`\
  ADD CONSTRAINT `cities_region_id_foreign` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `communes`\
--\
ALTER TABLE `communes`\
  ADD CONSTRAINT `communes_city_id_foreign` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `companies`\
--\
ALTER TABLE `companies`\
  ADD CONSTRAINT `companies_city_id_foreign` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `companies_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `companies_has_services_list`\
--\
ALTER TABLE `companies_has_services_list`\
  ADD CONSTRAINT `companies_has_services_list_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `companies_has_services_list_service_list_id_foreign` FOREIGN KEY (`service_list_id`) REFERENCES `services_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `contracts`\
--\
ALTER TABLE `contracts`\
  ADD CONSTRAINT `contracts_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`);\
\
--\
-- Constraints for table `conversations`\
--\
ALTER TABLE `conversations`\
  ADD CONSTRAINT `conversations_contact_id_foreign` FOREIGN KEY (`contact_id`) REFERENCES `users` (`id`),\
  ADD CONSTRAINT `conversations_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);\
\
--\
-- Constraints for table `coupons`\
--\
ALTER TABLE `coupons`\
  ADD CONSTRAINT `coupons_membership_id_foreign` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `det_scoring`\
--\
ALTER TABLE `det_scoring`\
  ADD CONSTRAINT `det_scoring_cat_scoring_id_foreign` FOREIGN KEY (`cat_scoring_id`) REFERENCES `cat_scoring` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `files`\
--\
ALTER TABLE `files`\
  ADD CONSTRAINT `files_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `files_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `files_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `memberships`\
--\
ALTER TABLE `memberships`\
  ADD CONSTRAINT `memberships_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `messages`\
--\
ALTER TABLE `messages`\
  ADD CONSTRAINT `messages_from_id_foreign` FOREIGN KEY (`from_id`) REFERENCES `users` (`id`),\
  ADD CONSTRAINT `messages_to_id_foreign` FOREIGN KEY (`to_id`) REFERENCES `users` (`id`);\
\
--\
-- Constraints for table `newsletters`\
--\
ALTER TABLE `newsletters`\
  ADD CONSTRAINT `newsletters_commune_id_foreign` FOREIGN KEY (`commune_id`) REFERENCES `communes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `payments`\
--\
ALTER TABLE `payments`\
  ADD CONSTRAINT `payments_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`),\
  ADD CONSTRAINT `payments_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,\
  ADD CONSTRAINT `payments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);\
\
--\
-- Constraints for table `photos`\
--\
ALTER TABLE `photos`\
  ADD CONSTRAINT `photos_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `photos_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `photos_service_list_id_foreign` FOREIGN KEY (`service_list_id`) REFERENCES `companies_has_services_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `photos_space_id_foreign` FOREIGN KEY (`space_id`) REFERENCES `spaces` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `photos_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `postulates`\
--\
ALTER TABLE `postulates`\
  ADD CONSTRAINT `postulates_id_foreign` FOREIGN KEY (`id`) REFERENCES `users_has_properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `properties`\
--\
ALTER TABLE `properties`\
  ADD CONSTRAINT `properties_city_id_foreign` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `properties_commune_id_foreign` FOREIGN KEY (`commune_id`) REFERENCES `communes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `properties_company_id_foreign` FOREIGN KEY (`company_id`) REFERENCES `companies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `properties_executive_id_foreign` FOREIGN KEY (`executive_id`) REFERENCES `useradmins` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,\
  ADD CONSTRAINT `properties_property_type_id_foreign` FOREIGN KEY (`property_type_id`) REFERENCES `properties_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `properties_has_amenities`\
--\
ALTER TABLE `properties_has_amenities`\
  ADD CONSTRAINT `properties_has_amenities_amenity_id_foreign` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `properties_has_amenities_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `properties_has_properties_for`\
--\
ALTER TABLE `properties_has_properties_for`\
  ADD CONSTRAINT `properties_has_properties_for_property_for_id_foreign` FOREIGN KEY (`property_for_id`) REFERENCES `properties_for` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `properties_has_properties_for_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `regions`\
--\
ALTER TABLE `regions`\
  ADD CONSTRAINT `regions_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `sasapplicants`\
--\
ALTER TABLE `sasapplicants`\
  ADD CONSTRAINT `sasapplicants_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `schedules`\
--\
ALTER TABLE `schedules`\
  ADD CONSTRAINT `schedules_id_foreign` FOREIGN KEY (`id`) REFERENCES `users_has_properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `services_list`\
--\
ALTER TABLE `services_list`\
  ADD CONSTRAINT `services_list_service_type_id_foreign` FOREIGN KEY (`service_type_id`) REFERENCES `services_type` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `users`\
--\
ALTER TABLE `users`\
  ADD CONSTRAINT `users_bank_id_foreign` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_city_id_foreign` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_civil_status_id_foreign` FOREIGN KEY (`civil_status_id`) REFERENCES `civil_status` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_collateral_id_foreign` FOREIGN KEY (`collateral_id`) REFERENCES `users` (`id`) ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON UPDATE CASCADE;\
\
--\
-- Constraints for table `users_has_amenities`\
--\
ALTER TABLE `users_has_amenities`\
  ADD CONSTRAINT `users_has_amenities_amenity_id_foreign` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_has_amenities_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `users_has_contracts`\
--\
ALTER TABLE `users_has_contracts`\
  ADD CONSTRAINT `users_has_contracts_contract_id_foreign` FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`),\
  ADD CONSTRAINT `users_has_contracts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);\
\
--\
-- Constraints for table `users_has_coupons`\
--\
ALTER TABLE `users_has_coupons`\
  ADD CONSTRAINT `users_has_coupons_coupon_id_foreign` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_has_coupons_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `users_has_memberships`\
--\
ALTER TABLE `users_has_memberships`\
  ADD CONSTRAINT `users_has_memberships_membership_id_foreign` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_has_memberships_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `users_has_notifications`\
--\
ALTER TABLE `users_has_notifications`\
  ADD CONSTRAINT `users_has_notifications_notification_id_foreign` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_has_notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `users_has_privacies`\
--\
ALTER TABLE `users_has_privacies`\
  ADD CONSTRAINT `users_has_privacies_privacy_id_foreign` FOREIGN KEY (`privacy_id`) REFERENCES `privacies` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_has_privacies_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `users_has_properties`\
--\
ALTER TABLE `users_has_properties`\
  ADD CONSTRAINT `users_has_properties_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `users_has_properties_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `user_provider`\
--\
ALTER TABLE `user_provider`\
  ADD CONSTRAINT `user_provider_provider_id_foreign` FOREIGN KEY (`provider_id`) REFERENCES `providers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,\
  ADD CONSTRAINT `user_provider_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;\
\
--\
-- Constraints for table `visits`\
--\
ALTER TABLE `visits`\
  ADD CONSTRAINT `visits_property_id_foreign` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;}