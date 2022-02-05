# Richtig Themen
## Themes verwenden
> Alle Elemente, welche ein bestimmtes Aussehen haben, welches abhängig von dem verwendeten Design ist, haben einen Eintrag in DesignPackage, entweder direkt, wie zum Beispiel primaryColor, oder als Klasse, wie textStyle

> Ein Style oder eine Farbe des verwendeten Designs kann mit dem Syntax
>
> AppDesign.current.(was man braucht)
> 
> bekommen werden. Diese können, sofern überhaupt vorhanden, auch direkt in theming.dart nachgeschaut werden. Im Fall von Text styles kann in der Klasse TextStyles in derselben Datei nachgeschaut werden

> Alle Themes sind in der Klasse Designs zu finden, sowie die methode randomTheme welche auch von dem Plus Button in der Ecke benutzt wird, um ein random Theme zu setzen

# Konstante Design sachen
> Es gibt auch konstante welche aber mehrmals in der App gebraucht werden und die sich nicht ändern, die kann man auch theming.dart finden. Zum Beispiel der border radius von Boxen (Wobei man den glaub ich nur 1 oder 2 mal braucht)


# Eigene Themes
> Themes können mit der Funktion generateAppTheme() generiert werden. Die Parameter sind
> 
> primaryColor = Die Hauptfarbe, zum Beispiel der Hintergrund von der Warning Box
> 
> backgroundColor = Halt die Hintergrundfarbe, wird von dem Scaffold verwendet
> 
> boxBackground = Die Farbe von normalen Boxen, meist nur minimal heller als der Hintergrund um nicht so aufzufallen
> 
> textColor = Die allgemeine Farbe von Texten
> 
> contrastColor = Die Farbe die am besten auf primaryColor zu sehen ist, damit zum Beispiel der Text in warning box auch sichtbar ist