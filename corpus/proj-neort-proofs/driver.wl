(* Driver: loads the harness, runs one chapter suite, writes results JSON.
   Usage: math -script scripts/driver.wl mathematica/chapters/<file>.wl
   Requires NEORT_PROOFS_ROOT in the environment. *)
root = Environment["NEORT_PROOFS_ROOT"];
If[root === $Failed || root === None,
   root = FileNameDrop[DirectoryName[$InputFileName], -1]];
Get[FileNameJoin[{root, "mathematica", "lib", "Verify.wl"}]];
chapter = Environment["NEORT_CHAPTER"];
Verify`BeginSuite[FileBaseName[chapter]];
Get[chapter];
Verify`EndSuite[
  FileNameJoin[{root, "mathematica", "results", FileBaseName[chapter] <> ".json"}]];
