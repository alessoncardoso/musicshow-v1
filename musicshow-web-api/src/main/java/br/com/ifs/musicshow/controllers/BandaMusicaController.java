package br.com.ifs.musicshow.controllers;

import br.com.ifs.musicshow.dtos.BandaMusicaDto;
import br.com.ifs.musicshow.models.BandaMusicaModel;
import br.com.ifs.musicshow.repositories.BandaMusicaRepository;
import br.com.ifs.musicshow.services.BandaMusicaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@CrossOrigin("*")
@RequestMapping("/banda-musica")
@RequiredArgsConstructor
public class BandaMusicaController {

    private final BandaMusicaService bandaMusicaService;

    private final BandaMusicaRepository bandaMusicaRepository;

    @GetMapping("/listar")
    public ResponseEntity<List<BandaMusicaDto>> listarTodasAssociacoes() {
        List<BandaMusicaDto> associacoes = bandaMusicaService.listarTodasAssociacoes();
        return ResponseEntity.ok(associacoes);
    }

    @GetMapping("/listar/{idRepertorio}")
    public ResponseEntity<List<BandaMusicaDto>> listarAssociacoesPorRepertorio(@PathVariable Integer idRepertorio) {
        List<BandaMusicaDto> associacoes = bandaMusicaService.listarAssociacoesPorRepertorio(idRepertorio);
        return ResponseEntity.ok(associacoes);
    }

    @PutMapping("/reordenar-musica")
    public ResponseEntity<Void> reordenarMusicas(@RequestBody List<BandaMusicaModel> musicas) {
        bandaMusicaService.reordenarMusicas(musicas);
        return ResponseEntity.ok().build();
    }

    // Cadastrar - OK
    @PostMapping("/adicionar-musica")
    public ResponseEntity<String> adicionarMusica(@RequestBody @Valid BandaMusicaDto bandaMusicaDto) {
        try {
            bandaMusicaService.adicionarMusica(bandaMusicaDto);
            return ResponseEntity.status(HttpStatus.CREATED).body("Associação criada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        }
    }

    @DeleteMapping(value = "/remover-musica")
    public ResponseEntity<String> removerMusica(@RequestBody BandaMusicaDto bandaMusicaDto) {
        try {
            bandaMusicaService.removerMusica(bandaMusicaDto);
            return ResponseEntity.status(HttpStatus.OK).body("Associação removido com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @PostMapping("/cadastrar")
    public ResponseEntity<String> cadastrarBandaMusica(@RequestBody @Valid BandaMusicaDto bandaMusicaDto) {
        try {
            bandaMusicaService.cadastrarBandaMusica(bandaMusicaDto);
            return ResponseEntity.status(HttpStatus.CREATED).body("Associação criada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT).body(e.getMessage());
        }
    }

    // Atualizar - OK
    @PutMapping(value = "/atualizar/{id}")
    public ResponseEntity<String> atualizarBandaMusica(@PathVariable Integer id,
                                                        @RequestBody @Valid BandaMusicaDto bandaMusicaDto) {
        try {
            bandaMusicaService.atualizarBandaMusica(id, bandaMusicaDto);
            return ResponseEntity.ok("Associação atualizada com sucesso.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }

}
