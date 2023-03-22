function chat(message, temps::Float64)
    texte = open("file","w")
    write(texte, message)
    write(texte, "\n")
    close(texte)
    texte = open("file","r")
    while !eof(texte)
        lettre = read(texte, Char)
        print(lettre)
        sleep(temps)
    end
    close(texte)
    rm("file")
end
datas = open("data","w")
write(datas, "titre d'accueil dans votre bloc-note perso\nmots latents sur la zone de saisie du mot de passe\nmot à inscrire sur le bouton qui va servir à valider le mot de passe\nnombre de secondes avant le rafraîchissement automatique du bloc-note\ntitre de ton bloc-note\nmots latents dans la zone de saisie des notes\nmot à inscrire sur le bouton d'envoi\nmot à inscrire sur le bouton de rafraîchissement\nmot à inscrire sur le bouton de déconnexion")
close(datas)
chat("Salut à vous!\n Je vais me charger de vous créer un cloud bloc-note \n  qui vous permettra de conserver vos notes textuelles sur le Cloud\n    Veuillez remplir les fichiers qui viennent juste d'être créés \n    avec les données correspondantes\n", 0.015)
chat("Pressez la touche 'c' lorsque vous aurez terminé svp", 0.015)
datas = readline()
while uppercase(datas) != uppercase("c")
    chat("Il faut presser la touche 'c' ; pas $datas", 0.011)
    global datas = readline()
end
datas = open("data","r")
data = []
for i in eachline(datas)
    push!(data, i)
end
close(datas)
titre_log = data[1]
pswd_txt = data[2]
valid_word = data[3]
frequency = data[4]
titre_notes = data[5]
filigran_text = data[6]
post_word = data[7]
fresh = data[8]
logout_but = data[9]
chat("Définissez un mot de passe pour votre cloud bloc-note", 0.012)
mot_de_passe = readline()
loginpage = """<?php\nsession_start();\n\$_SESSION["motdepasse"] = "$mot_de_passe";\n\$_SESSION["passmot"] = "";\n?>\n<!DOCTYPE html style="backdrop-filter: blur(10px);">\n<html>\n<head>\n<meta charset="UTF-8">\n<link rel="stylesheet" href="https://3uitnolvypnnvmkvd3asra.on.drv.tw/cloudNote/style.css">\n<title>Private Note #Powered by V.I.A.A</V></title>\n</head>\n<body style="backdrop-filter: blur(10px);">\n<h1>$titre_log</h1>\n<form method="post" class="message-form">\n    <input placeholder="$pswd_txt" name="pswd" id="message" class="message-input">\n    <p>\n    <button type="submit" class="send-button">$valid_word</button>\n    <?php\n        if (isset(\$_POST['pswd'])) {\n            if (\$_POST['pswd'] == \$_SESSION["motdepasse"]) {\n                \$_SESSION["passmot"] = \$_POST['pswd'];\n                header("Location: chat.php#lastlast");\n                exit();\n            } else {\n                echo '<div style="background-color: transparent; backdrop-filter: blur(5px);"><h1>non ... !</h1></div>';\n            }\n        }\n    ?>\n    </p>\n</form>\n</body>\n</html>"""
notepage = """<?php\nsession_start();\nif (empty(\$_SESSION["motdepasse"]) || empty(\$_SESSION["passmot"])) {\n    header("Location: index.php");\n}\nif (\$_SESSION["motdepasse"] != \$_SESSION["passmot"]) {\n    header("Location: index.php");\n}\n?>\n\n<!DOCTYPE html>\n<html>\n<head>\n<meta http-equiv="refresh" content="$frequency">\n<meta charset="UTF-8">\n<link rel="stylesheet" href="https://3uitnolvypnnvmkvd3asra.on.drv.tw/cloudNote/style.css">\n<title>Private notes</title>\n</head>\n<body>\n<h1>$titre_notes</h1>\n<div id="messages" class="message-list">\n    <?php\n        \$filepath = 'messages.txt';\n        \$messages = array();\n        if (file_exists(\$filepath) && is_readable(\$filepath)) {\n            \$messages = array_reverse(file(\$filepath, FILE_IGNORE_NEW_LINES));\n        }\n        if (count(\$messages) === 0) {\n            echo "<p>N'hésitez pas à écrire quelque chose ...</p>";\n        } else {\n            foreach (array_reverse(\$messages) as \$message) {\n                echo '<div class="message">' . htmlspecialchars(\$message) . '</div>';\n            }\n        }\n    ?>\n    <br id="lastlast">\n</div>\n<form method="post" class="message-form">\n    <textarea placeholder="$filigran_text" id="message" name="message" rows="5" cols="50" class="message-input"></textarea>\n    <p>\n    <button type="submit" name="fresh" class="send-button">$post_word</button>\n    <button name="fresh" class="send-button">$fresh</button>\n    <?php\n        if (isset(\$_POST['fresh'])) {\n            header("Location: chat.php#lastlast");\n        }\n    ?>\n    </p>\n</form>\n<?php\n    if (isset(\$_POST['message'])) {\n        \$new_message = trim(\$_POST['message']);\n        if (!empty(\$new_message)) {\n            \$file = fopen(\$filepath, 'a');\n            fwrite(\$file, \$new_message . PHP_EOL);\n            fclose(\$file);\n            header('Location: ' . \$_SERVER['PHP_SELF']);\n            exit;\n        }\n    }\n?>\n<form method="post" class="message-form">\n    <button type="submit" name="sortie" class="exit-button">$logout_but</button>\n    <?php\n        if (isset(\$_POST['sortie'])) {\n                header("Location: index.php");\n                session_destroy();\n                exit();\n        }\n    ?>\n</form>\n</body>\n</html>"""
datas = open("index.php","w")
write(datas, loginpage)
close(datas)
datas = open("chat.php","w")
write(datas, notepage)
close(datas)
chat("Votre cloud bloc-note est prêt !\n Nous nous chargerons de le mettre sur le cloud.\n  Envoyez-nous ces 2 fichiers par mail à l'adresse toolsgifts@gmail.com :\n\n       index.php et chat.php", 0.015)
